today=$(date +'%Y-%m-%d')
start_time=$(date -d $today' 09:00:00 GMT+8' +%s%N)
start_time=$((${start_time}/1000))
end_time=$(date -d $today' 13:30:00 GMT+8' +%s%N)
end_time=$((${end_time}/1000))

redis-cli ft.search timeIdx "@closeTime:[$start_time $end_time]" \
  sortby closeTime desc \
  limit 0 1 return 9 \
  $.closeTime \
  $.total.tradeValue \
  $.total.tradeVolume \
  $.total.tradeVolumeAtBid \
  $.total.tradeVolumeAtAsk \
  $.lastTrade.bid \
  $.lastTrade.ask \
  $.lastTrade.price \
  $.lastTrade.size | \
  sed -n 2,20p | xargs -L 19 | awk '{print $3, $5, $7, $9, $11, $13, $15, $17, $19}' | while read i j k l m n o p q;
do
  ts=$((${i}/1000000))
  time_info=$(TZ=GMT-8 date +'%Y-%m-%d %H:%M:%S' -d $(echo @$ts))
  data_time=$(echo $time_info | cut -f 2 -d ' ') 
  echo Redis input data time: $data_time
  tail -1 stock_time_series_data_$(date +'%Y%m%d').txt | cut -f 2,3,4,5,6 -d ' ' | while read v w x y z;  
  do
    if [ $v = 'Time' ];
      then 
        echo $time_info $j $k $l $m $n $o $p $q $((${j}/${k})) - - - - >> stock_time_series_data_$(date +'%Y%m%d').txt;
    elif [ $v != 'Time' ] && [ $v != $data_time ];
      then
        echo $time_info $j $k $l $m $n $o $p $q $((${j}/${k})) $(((${j}-${w})/(${k}-${x}))) $((${k}-${x})) $((${l}-${y})) $((${m}-${z})) >> stock_time_series_data_$(date +'%Y%m%d').txt;
    else
      echo No new data to be written to file.;
    fi;
  done
done
