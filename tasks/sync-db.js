
let times = 0;

const syncDB = () => {
   times++;
   console.log('Tick every 5 seconds: ', times);
   return times;
}

module.exports = {
   syncDB
}