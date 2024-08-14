VIRTUALENV_PATH=/home/squarefish75/python_envs/fugle_env
PROJECT_PATH=$(pwd) #$(dirname $0)

tic=$(date +%s%N) \
  && output=$(echo $($VIRTUALENV_PATH/bin/python $PROJECT_PATH/get_intraday_stock_data.py)) \
  && pytoc=$(date +%s%N) \
  && data=$(echo ${output//"'"/'"'}) \
  && data=$(echo ${data/'"{'/"{"}) \
  && data=$(echo ${data/'}"'/"}"}) \
  && stockid=$(echo $output | cut -f 5 -d ',' | cut -f 2 -d ':' | cut -f 2 -d "'") \
  && closetime=$(echo $output | cut -f 16 -d ',' | cut -f 2 -d ':') \
  && redis-cli json.set "$stockid:$(echo $closetime)" "." "$data" \
  && redistoc=$(date +%s%N)

echo Time spent on getting real-time stock data: $(((${pytoc}-${tic})/1000000)) ms
echo Time spent on writing data to Redis: $(((${redistoc}-${pytoc})/1000000)) ms
