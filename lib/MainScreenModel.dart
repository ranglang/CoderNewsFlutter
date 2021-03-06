import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'Network.dart';
import 'package:flutter/material.dart';
import 'Constants.dart';
import 'BlockPage.dart';

class MainModel{

  //获取数据颜色
  var currentTilesIndex = 0;
  var currentTilesColorIndex = 0;

  var currentCategoryArray = ["java","python","swift"];
  var currentQueueHeadArray = [1,1,1];
  //获取tiles
  List<StaggeredTile> getATileList(heightIs4){
    var tileArray = heightIs4 ? ConstantsForTile.staggeredTiles4by2 : ConstantsForTile.staggeredTiles3by2;
    var constantsLength = tileArray.length;
    if (currentTilesIndex < constantsLength){
      var result = tileArray[currentTilesIndex];
      currentTilesIndex = currentTilesIndex == constantsLength-1 ? 0 : currentTilesIndex+1 ;
      return result;
    }else{
      print("currentTilesConstants报错");
    }
  }
  //获取颜色
  Color getATileColor(){
    var constantsLength = ConstantsForTile.colorsList.length;
    if (currentTilesColorIndex < constantsLength){
      var result = ConstantsForTile.colorsList[currentTilesColorIndex];
      currentTilesColorIndex = currentTilesColorIndex == constantsLength-1 ? 0 : currentTilesColorIndex+1 ;
      return result;
    }else{
      print("currentTilesColorIndex报错");
    }
  }
  //获取Widgets
  Future<List<Blocks>> getWidgets(List tileList) async {
    print("GetWidgets");
    var rawJson = await getMainScreenDatas(currentCategoryArray, tileList.length, currentQueueHeadArray);
    List jsonArray = rawJson["data"];
    List<Blocks> result = [];
    jsonArray.asMap().forEach((indexForData,data){
      //队首进行更新 只能处理单个标签的情况
      var tagName = data["infoId__category"];
      for (var index = 0;index < currentCategoryArray.length;index++){
        var categoryName = currentCategoryArray[index];
        if (categoryName == tagName) {
          currentQueueHeadArray[index]++;
//          print(currentQueueHeadArray);
          break;
        }
      }
//      print(data);
      var id = data["infoId"].toString();
      var height = tileList[indexForData].mainAxisCellCount;
//      print(height);
      var color = getATileColor();
      Blocks widget = Blocks.withJson(Key(id),data,height*3,color);
      result.add(widget);
    });

    //更新
    return result;
  }


}


