#!/bin/bash

set -ex

charts_dir="/tmp/charts"

function cleanup() {
  rm -rf ${charts_dir}
  mkdir -p ${charts_dir}
}

function save_chart_for_symbol() {
  local symbol=$1

  echo "Getting chart for ${symbol}"

  curl -o ${charts_dir}/${symbol}.png "https://chart.finance.yahoo.com/z?s=${symbol}&t=6m&q=l&l=on&z=l&p=m50,e200,v&a=r14,m12-26-9"

}

function mail_charts() {
  zip -r ${charts_dir}.zip ${charts_dir}

  timestamp=$(date)

  echo "Charts @ ${timestamp}" | mail -v -a ${charts_dir}.zip -s "Charts @ ${timestamp}" anuragsingh84@gmail.com
}

if [ $# -ne 1 ];
then
  echo "Usage: fetch_charts.sh <symbol list file>"
  exit 1
fi

symbol_file=$1

if [ ! -f ${symbol_file} ];
then
  echo "${symbol_file} doesn't exist or isn't a regular file"
  exit 1
fi

echo "Getting stock data for stock in ${symbol_file}"

symbols=$(cat ${symbol_file})

cleanup

for symbol in ${symbols}
do
  save_chart_for_symbol ${symbol}
done

mail_charts

