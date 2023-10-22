

site:
	hugo

dev_site:
	hugo -D server

publish: site
	(cd public && rsync -av --exclude="scores" --exclude="sounds" --exclude="images" . adam@tanne:/var/www/webserver/admccartney.mur.at/webseite)

