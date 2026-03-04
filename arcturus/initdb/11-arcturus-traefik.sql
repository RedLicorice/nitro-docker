-- requirements for the camera mod
UPDATE emulator_settings SET `value`='https://squarello.duckdns.org/usercontent/camera/' WHERE  `key`='camera.url';
-- because we have no image.php proxy which is set by default to proxy youtube images we do a microservice aproach by proxy data through a go service
UPDATE emulator_settings SET `value`='https://squarello.duckdns.org/api/imageproxy/0x0/http://img.youtube.com/vi/%video%/default.jpg' WHERE  `key`='imager.url.youtube';
