import 'game.dart';

class Tool {
  // 返回已被選擇的位置.
  static getCanSelectSet(List<dynamic>? canSelect) {
    Map analyzeData = {};
    if (canSelect == null) return analyzeData;
    canSelect.forEach((item) {
      if (item['isHasValue']) analyzeData[item['index']] = item['value'];
    });
    // print('analyzeSet $analyzeData.');
    return analyzeData;
  }

  // 依照結果分析所在位置.
  static getAnalyzeCanSelectSet(List<dynamic>? canSelect) {
    Map analyzeData = {};
    analyzeData[Player.circle] = [];
    analyzeData[Player.fork] = [];
    if (canSelect == null) return analyzeData;
    canSelect.forEach((item) {
      if (item['isHasValue']) {
        // analyzeData[item['index']] = item['value'];
        if (item['value'] == Player.circle) {
          analyzeData[Player.circle].add(item['index']);
        } else {
          analyzeData[Player.fork].add(item['index']);
        }
      }
    });
    // print('analyzeSet $analyzeData.');
    return analyzeData;
  }

  // 列出陣列中，選擇兩個數的所有組合.
  static getAnalyzeSelectTwoNum(List baseArr) {
    // print('getAnalyzeSelectTwoNum >>> $baseArr');
    Set outputArr = {};
    if (baseArr.length < 2) return outputArr;

    baseArr.forEach((n) {
      Set newArr = {};
      newArr.add(n);
      baseArr.forEach((m) {
        newArr.add(m);
        if (newArr.toList().length == 2) {
          if (outputArr.toList().length == 0) {
            outputArr.add(newArr);
          }
          // 比對 outputArr 是否有相同組合
          outputArr.forEach((group) {
            // print('ttttt newArr >>> $newArr - ${group.intersection(newArr)}');
            if (group.intersection(newArr).toList().length < 2) {
              outputArr.add(newArr);
            }
          });
        }
      });
    });
    // print('outputArr >>> $outputArr');
    return outputArr;
  }
}
