## Redis應用: 股票盤中趨勢分析  ##

<ins>說明</ins>: 

呼叫玉山富果即時行情API擷取股票交易資料，儲存到Redis，使用`redis-cli`和shell scripts處理資料和分析。

<ins>使用到的雲端資源</ins>： 
 
 - 虛擬機(VM)：使用Linux Debian bullseye (Redis stack server似乎不支援bookworm版本)

<ins>步驟</ins>: 

 **(1)** 安裝Redis server和Redis stack server

```
# 安裝Redis server
sudo apt-get update
sudo apt-get install redis

# Redis server安裝後會自動啟動，先停止它
sudo systemctl stop redis-server

# 安裝Redis stack server
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt-get update
sudo apt-get install redis-stack-server

# 啟動Redis stack server
sudo systemctl enable redis-stack-server
sudo systemctl start redis-stack-server
```

 **(2)** 建立Python虛擬環境，安裝玉山富果套件

   虛擬環境路徑和名稱： `./python_envs/fugle_env`

   安裝套件
```
pip install fugle-marketdata
```

 **(3)** 執行`start_job.sh`開始收集股票交易資料，寫入Redis

   每隔2秒呼叫行情API取得股票交易資料，存入Redis，計算每個時間點的內外盤變化。

   上述時間序列資料儲存在`stock_time_series_data_[日期].txt`檔。





