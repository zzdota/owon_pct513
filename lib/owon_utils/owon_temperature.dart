class OwonTemperature {
  var cTemp = [
    0,
    50,
    100,
    150,
    200,
    250,
    300,
    350,
    400,
    450,
    500,
    550,
    600,
    650,
    700,
    750,
    800,
    850,
    900,
    950,
    1000,
    1050,
    1100,
    1150,
    1200,
    1250,
    1300,
    1350,
    1400,
    1450,
    1500,
    1550,
    1600,
    1650,
    1700,
    1750,
    1800,
    1850,
    1900,
    1950,
    2000,
    2050,
    2100,
    2150,
    2200,
    2250,
    2300,
    2350,
    2400,
    2450,
    2500,
    2550,
    2600,
    2650,
    2700,
    2750,
    2800,
    2850,
    2900,
    2950,
    3000,
    3050,
    3100,
    3150,
    3200,
    3250,
    3300,
    3350,
    3400,
    3450,
    3500,
    3550,
    3600,
    3650,
    3700,
    3750,
    3800,
    3850,
    3900,
    3950,
    4000,
    4050,
    4100,
    4150,
    4200,
    4250,
    4300,
    4350,
    4400,
    4450,
    4500,
    4550,
    4600
  ];
  var fTemp = [
    3200,
    3300,
    3400,
    3500,
    3600,
    3700,
    3700,
    3800,
    3900,
    4000,
    4100,
    4200,
    4300,
    4400,
    4500,
    4600,
    4600,
    4700,
    4800,
    4900,
    5000,
    5100,
    5200,
    5300,
    5400,
    5500,
    5500,
    5600,
    5700,
    5800,
    5900,
    6000,
    6100,
    6200,
    6300,
    6400,
    6400,
    6500,
    6600,
    6700,
    6800,
    6900,
    7000,
    7100,
    7200,
    7300,
    7300,
    7400,
    7500,
    7600,
    7700,
    7800,
    7900,
    8000,
    8100,
    8200,
    8200,
    8300,
    8400,
    8500,
    8600,
    8700,
    8800,
    8900,
    9000,
    9100,
    9100,
    9200,
    9300,
    9400,
    9500,
    9600,
    9700,
    9800,
    9900,
    10000,
    10000,
    10100,
    10200,
    10300,
    10400,
    10500,
    10600,
    10700,
    10800,
    10900,
    10900,
    11000,
    11100,
    11200,
    11300,
    11400,
    11500
  ];

  int cToF(double c) {
    int fTempBuf = 0;
    String valueBuf = c.toString();
    int length = valueBuf.indexOf(".");
    int aa = int.parse(valueBuf.substring(length + 1, length + 2));
    int bb = c.toInt();
    if (aa >= 0 && aa <= 2) {
      aa = 0;
    } else if (aa >= 3 && aa <= 7) {
      aa = 5;
    } else if (aa == 8 || aa == 9) {
      aa = 0;
      bb += 1;
    }
    int temp = ((bb * 100) + aa * 10).toInt();
    for (int i = 0; i < cTemp.length; i++) {
      if (temp == cTemp[i]) {
        fTempBuf = fTemp[i];
        break;
      }
    }
    return fTempBuf ~/ 100;
  }

  double fToC(int f) {
    int cTempBuf = 0;
    int temp = (f * 100).toInt();
    for (int i = 0; i < fTemp.length; i++) {
      if (temp == fTemp[i]) {
        cTempBuf = cTemp[i];
        break;
      }
    }
    return (cTempBuf / 100.0).toDouble();
  }

  int c100ToF100(int c) {
    int fTempBuf = 0;
    for (int i = 0; i < cTemp.length; i++) {
      if (c == cTemp[i]) {
        fTempBuf = fTemp[i];
        break;
      }
    }
    return fTempBuf;
  }

  int f100ToC100(int f) {
    int cTempBuf = 0;
    for (int i = 0; i < fTemp.length; i++) {
      if (f == fTemp[i]) {
        cTempBuf = cTemp[i];
        break;
      }
    }
    return cTempBuf;
  }

  String c100ToF100String(String c) {
    int fTempBuf = 0;
    for (int i = 0; i < cTemp.length; i++) {
      if (int.parse(c) == cTemp[i]) {
        fTempBuf = fTemp[i];
        break;
      }
    }
    return fTempBuf.toString();
  }

  String f100ToC100String(String f) {
    int cTempBuf = 0;
    for (int i = 0; i < fTemp.length; i++) {
      if (int.parse(f) == fTemp[i]) {
        cTempBuf = cTemp[i];
        break;
      }
    }
    return cTempBuf.toString();
  }
}
