for use s3 storage, we use s3fs-fuse for mounting disk s3 to local server
sometimes if you use a remote url you often experience whitespace or images with file names that have space, 
then the browser will decode the space to %20, this will be sent to the thumbor server, 
and will be read by the thumbor as a file name, not a space but instead becomes NAME%20IMAGE.jpg
but it doesn't happen if we mount the file on the server

https://github.com/s3fs-fuse/s3fs-fuse
