class CloudinaryConstants {
  static const String cloudName = 'djkufgvvm';
  static const String uploadPreset = 'typetogo';

  static String uploadUrl({String resourceType = 'auto'}) =>
      'https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload';
}
