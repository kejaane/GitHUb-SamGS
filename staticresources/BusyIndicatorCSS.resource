     .busyIndicator {
      display: none;
    }

    .busyIndicator-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: #000;
      opacity: .2;
      filter: alpha(opacity=20);
      z-index: 9999;
    }

    .busyIndicator-img {
      position: fixed;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      margin: auto;
      width: auto;
      height: 14px;
      text-align: center;
      font-size: 14px;
    }

    .loading {
      border-radius: 50%;
      width: 24px;
      height: 24px;
      border: 0.25rem solid #6fbdff;
      border-top-color: #002bff;
      -webkit-animation: spin 1s infinite linear;
      animation: spin 1s infinite linear;
      margin: auto;
      margin-bottom: 10px;
    }

    @-webkit-keyframes spin {
      0% {
        -webkit-transform: rotate(0deg);
        transform: rotate(0deg);
      }

      100% {
        -webkit-transform: rotate(360deg);
        transform: rotate(360deg);
      }
    }

    @keyframes spin {
      0% {
        -webkit-transform: rotate(0deg);
        transform: rotate(0deg);
      }

      100% {
        -webkit-transform: rotate(360deg);
        transform: rotate(360deg);
      }
    }
