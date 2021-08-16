class CreateRatingRequest {
  late String orderName;
  late double rating;
  late String comments;

  CreateRatingRequest(
      {required this.orderName, required this.comments, required this.rating});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = this.orderName;
    data['rating'] = this.rating.toInt();
    data['comments'] = this.comments;

    return data;
  }
}
