publish:
	@dart format lib
	@git add .
	@git commit -m "Fixed bugs and added features"
	@git push
	@dart pub publish

GenIcons: 
	@dart tools/icons.dart