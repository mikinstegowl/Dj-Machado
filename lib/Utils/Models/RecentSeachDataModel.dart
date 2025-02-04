class RecentSearchDataModel {
  int? status;
  String? message;
  List<TrendinglistData>? trendinglistData;
  List<TrendinglistData>? recentList;

  RecentSearchDataModel(
      {this.status, this.message, this.trendinglistData, this.recentList});

  RecentSearchDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['trendinglist_data'] != null) {
      trendinglistData = <TrendinglistData>[];
      json['trendinglist_data'].forEach((v) {
        trendinglistData!.add(new TrendinglistData.fromJson(v));
      });
    }
    if (json['recent_list'] != null) {
      recentList = <TrendinglistData>[];
      json['recent_list'].forEach((v) {
        recentList!.add(new TrendinglistData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.trendinglistData != null) {
      data['trendinglist_data'] =
          this.trendinglistData!.map((v) => v.toJson()).toList();
    }
    if (this.recentList != null) {
      data['recent_list'] = this.recentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrendinglistData {
  int? recentsearchId;
  int? userId;
  String? text;

  TrendinglistData({this.recentsearchId, this.userId, this.text});

  TrendinglistData.fromJson(Map<String, dynamic> json) {
    recentsearchId = json['recentsearch_id'];
    userId = json['user_id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recentsearch_id'] = this.recentsearchId;
    data['user_id'] = this.userId;
    data['text'] = this.text;
    return data;
  }
}
