class ContainerModel {
  final String medName;
  final String containerID;
  final String medCategory;
  final int containerNum;
  final bool isActive;

  ContainerModel(
      {required this.medName,
      this.containerID = '',
      required this.medCategory,
      required this.containerNum,
      this.isActive = false});

  Map<String, dynamic> toJson() => {
        'medName': medName,
        'containerID': containerID,
        'medCategory': medCategory,
        'containerNum': containerNum,
        'isActive': isActive,
      };

  static ContainerModel fromJson(Map<String, dynamic> json) => ContainerModel(
      medName: json['medName'],
      containerID: json['containerID'],
      medCategory: json['medCategory'],
      containerNum: json['containerNum'],
      isActive: json['isActive']);
}
