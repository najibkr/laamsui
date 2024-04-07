publish:
	@dart format lib
	@git add .
	@git commit -m "Fixed bugs and added features"
	@git push
	@dart pub publish

GenIcons: 
	@dart tools/icons.dart


GenConsts:
	# @hoshmand gen consts --path=assets/images --dest=lib/src/constants/src/images_constants.dart --lang=dart
	@hoshmand gen consts --path=assets/svgs --dest=lib/src/constants/svgs_constants.dart --lang=dart
