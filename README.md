# FieldTrip

1. Once you start the application you need to authorize the location services .
2. To simulate location change we have included a gpx file named syracuse .It has two points. So the application will move to and fro from these places.\
3. Our application has four tabs. They are Nearby,Map,Favorites,Photos.
4. Nearby Tab: After the authorization process you will be presented a list of places nearby you.
	Click on a place to view its description. 
	You have the option to mark the place as  a favorite place by clicking the star at the top.
	You can also share the description by clicking on share button. This will open up whatsapp if it is installed.
5. Map Tab: You will presented with all the annotation of the places nearby you. 
	Upon clicking the title of the place is displayed.
6. Favorites Tab: If you marked a place as a favorite it will appear here.
7. Photos Tab: This tab view takes a while to load because a lot of photos need to be downloaded .
		A collection of photos will appear here . On clicking a photo a full view of the photo is displayed.
		A camera NavigationBar Item is present on the top right. On clicking this camera is opened.
		Just click photo and select use photo . It automatically saves the image to the photos gallery.

Description of Files: 
FlickrAPiKey.h '97 Holds the key to flickr API
FlickrFetcher.h  '97 .h file for Flickr Fetcher\
FlickrFetcher.m  '97 Helper methods to retrieve information from flickr\
PlacesTableViewController.h '97 .h file for PlacesTableViewController\
PlacesTableViewController.m '97 table view controller for nearby places\
PlacesViewController.h '97 .h file of PlacesViewController\
PlacesViewController.m '97  Displays the description of a place \
MapViewController.h '97 .h file of MapViewController\
MapViewController.m '97 Displays a map\
MapModel.h '97 .h of the Map Model\
MapModel.m '97 Acts as model for the MapViewController\
FavoritesViewController.h '97 .h file Favorites View Controller\
FavoritesViewController.m '97 Table view controller for favorite places.\
FlickrPhotosViewController.h '97 .h file of FlickrPhotoViewController\
FlickrPhotosViewController.m '97 CollectionViewController for flickr photos\
PhotoModel.h '97 .h file of PhotoModel\
PhotoModel.m '97 Model for FlickrPhotosViewController\
ImageViewController.h '97 .h file of ImageView Controller\
ImagesViewController.m '97 Displays an full size image.\
