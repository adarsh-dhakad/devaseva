class AllCampaignsItem {
  String code;
  var createdBy;
  var description;
  var donorCount;
  var endDate;
  var featured;
  var id;
  var image;
  String name;
  var prasadRequest;
  var priority;
  var raisedAmount;
  var shortDesc;
  var status;
  var targetAmount;
  var templeCode;
  var templeId;
  var templeImage;
  String templeName;

  int getInt() {
    return id;
  }

  AllCampaignsItem(
      this.code,
      this.createdBy,
      this.description,
      this.donorCount,
      this.endDate,
      this.featured,
      this.id,
      this.image,
      this.name,
      this.prasadRequest,
      this.priority,
      this.raisedAmount,
      this.shortDesc,
      this.status,
      this.targetAmount,
      this.templeCode,
      this.templeId,
      this.templeImage,
      this.templeName);
}
