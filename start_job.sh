today=$(TZ=GMT-8 date +'%Y-%m-%d')
start_time=$(TZ=GMT-8 date -d $today' 09:00:00' +%s)
end_time=$(TZ=GMT-8 date -d $today' 13:30:00' +%s)
current_time=$(TZ=GMT-8 date +%s)
current_dir=$(dirname $0)
echo Date \
     Time \
     TradeValue \
     TradeVolume \
     TradeVolumeAtBid \
     TradeVolumeAtAsk \
     LastTradeBid \
     LastTradePrice \
     LastTradeAsk \
     LastTradeSize \
     AvgTradeValue \
     AvgIncrTradeValue \
     IncrTradeVolume \
     IncrTradeVolumeAtBid \
     IncrTradeVolumeAtAsk > stock_time_series_data_$(date +'%Y%m%d').txt
while [ "${current_time}" -gt "${start_time}" ] && [ "${current_time}" -lt "${end_time}" ];
do
  echo Heartbeats $ticker at $(TZ=CST6CDT date +%Y-%m-%d-%H:%M:%S)
  /bin/bash $current_dir/intraday_stock_data_to_redis.sh
  sh $current_dir/generate_time_series_stock_data.sh
  sleep 2
  current_time=$(TZ=GMT-8 date +%s)
done
