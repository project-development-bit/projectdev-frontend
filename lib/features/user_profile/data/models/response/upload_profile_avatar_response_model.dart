// {
//     "success": true,
//     "avatarUrl": "https://gigafaucet-images-s3.s3.ap-southeast-2.amazonaws.com/avatars/23/23-1763612578349-xjd7tsj1b6i1htwy.png"
// }

class UploadProfileAvatarResponseModel {
  final bool success;
  final String avatarUrl;
  UploadProfileAvatarResponseModel({
    required this.success,
    required this.avatarUrl,
  });

  factory UploadProfileAvatarResponseModel.fromJson(
      Map<String, dynamic> json) {
    return UploadProfileAvatarResponseModel(
      success: json['success'] as bool,
      avatarUrl: json['avatarUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'avatarUrl': avatarUrl,
    };
  }
}