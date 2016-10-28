<?php
   // error_reporting(E_ALL);
   // ini_set('display_errors', '1');
require_once "jssdk.php";
$jssdk = new JSSDK("appId", "appSecret");
$signPackage = $jssdk->GetSignPackage();
?>
<html>
<head>
  <meta charset="utf-8">
  <title>Dantarian Scanner</title>
  <style type="text/css">
    html{
      font-size: 20px;
    }
    body{
      margin: 0;
      background-color: #2E3432;
    }
    .tip{
      font-family: monospace;
      color: #EEE;
      font-size: 3rem;
      text-align: center;
      margin-top: 30%;
      -webkit-animation-name: loading;
              animation-name: loading;
      -webkit-animation-duration: 2000ms;
              animation-duration: 2000ms;
      -webkit-animation-iteration-count: infinite;
              animation-iteration-count: infinite;
      -webkit-animation-timing-function: linear;
              animation-timing-function: linear;
    }
    @-webkit-keyframes loading {
      0% { opacity: 0.3;}
      50%{ opacity: 1;}
      100% {opacity: 0.3;}
    }
    @keyframes loading {
      0% { opacity: 0.3;}
      50%{ opacity: 1;}
      100% {opacity: 0.3;}
    }
  </style>
</head>
<body>
  <div class="tip" id="preparing">Loading scanner...</div>
  <div class="tip" id="redirect" style="display:none">Redirecting...</div>
</body>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
wx.config({
  debug: false,
  appId: '<?php echo $signPackage["appId"];?>',
  timestamp: <?php echo $signPackage["timestamp"];?>,
  nonceStr: '<?php echo $signPackage["nonceStr"];?>',
  signature: '<?php echo $signPackage["signature"];?>',
    jsApiList: [
      'scanQRCode',
    ]
});
wx.ready(function () {
  wx.scanQRCode({
    needResult: 1,
    scanType: ["barCode"],
    desc: 'scanQRCode desc',
    success: function (res) {
      if(res.errMsg=="scanQRCode:ok")
      {
        document.getElementById('preparing').style.display = 'none';
        document.getElementById('redirect').style.display = 'block';
        isbn = res.resultStr.split(',')[1];
        <?php 
        if(isset($_GET['target']))
        {
          echo "window.location.replace(\"${_GET['target']}\"+isbn);";
        }
        ?>
      }
      else{
        alert('res.errMsg');
      }
    },
    fail: function (res) {
      alert('扫描失败！'+res.errMsg);
    },
    cancel: function (res){
      alert('扫描取消');
      wx.closeWindow();
    }
  });
});

wx.error(function (res) {
  alert(res.errMsg);
});
</script>
</html>