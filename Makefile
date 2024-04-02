publish:
	@git add .
	@git commit -m "Fixed bugs and added features"
	@dart pub publish

GenIcons: 
	@dart tools/icons.dart