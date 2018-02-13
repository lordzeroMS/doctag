# doctag

doctag is a document management software that will simplify your work and yield efficency for your private live.

Keep the overview of all your documents, only upload and tag it with the most important keywords and a date.

Overview page: 
![doc main screen](https://github.com/lordzeroMS/doctag/blob/master/images/doctag-s1.png)


Detail page:
![doc detail screen](https://github.com/lordzeroMS/doctag/blob/master/images/doctag-s2.png)


Upload page:
![doc upload screen](https://github.com/lordzeroMS/doctag/blob/master/images/doctag-s3.png)

## Installation
This DMS is tested with Apache and mysql on Debian Jessie. For the installation are some other software packages needed. 

We use convert from ImageMagick to convert pdf to images, tesseract to OCR the uploaded documents (for full text search) and git to manage the source code.

If you don't have Apache already installed please do it, you can use 
```
sudo apt-get apache2 apache2-utils libapache2-mod-php5 mysql-server php5-mysqlnd
```

Additional you have to install ImageMagick and tesseract, do this with 
```
sudo apt-get imagemagick tesseract-ocr tesseract-ocr-eng
```

If you need german for your OCR too, please do
```
sudo apt-get tesseract-ocr-deu
```

For easy updates I recommend to use git. 
```
sudo apt-get git
```


**Requirements all in one:**
```
sudo apt-get apache2 apache2-utils libapache2-mod-php5 mysql-server php5-mysqlnd imagemagick tesseract-ocr tesseract-ocr-eng tesseract-ocr-deu git
```

### Prepare MySQL ###
```

--
-- table structure for table `files`
--

CREATE TABLE IF NOT EXISTS `files` (
`id` int(11) NOT NULL,
  `pdfLocation` varchar(512) NOT NULL,
  `date` date DEFAULT NULL,
  `tumbnail` varchar(512) DEFAULT NULL,
  `orginal_name` varchar(512) DEFAULT NULL,
  `user` varchar(64) DEFAULT NULL,
  `ocrtext` longtext,
  `pdftext` longtext
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- table structure for table `fileToKeywordMap`
--

CREATE TABLE IF NOT EXISTS `fileToKeywordMap` (
  `fileID` int(11) NOT NULL,
  `keywordID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- table structure for table `keywords`
--

CREATE TABLE IF NOT EXISTS `keywords` (
`id` int(11) NOT NULL,
  `keyword` varchar(45) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- indices for table `files`
--
ALTER TABLE `files`
 ADD PRIMARY KEY (`id`), ADD KEY `pdfLocation` (`pdfLocation`(255)), ADD KEY `date` (`date`), ADD FULLTEXT KEY `ocrtext` (`ocrtext`), ADD FULLTEXT KEY `pdftext` (`pdftext`);

--
-- indices for table `fileToKeywordMap`
--
ALTER TABLE `fileToKeywordMap`
 ADD UNIQUE KEY `fileID_2` (`fileID`,`keywordID`), ADD KEY `fileID` (`fileID`), ADD KEY `keywordID` (`keywordID`);

--
-- indices for table `keywords`
--
ALTER TABLE `keywords`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `keyword_UNIQUE` (`keyword`);

```

### Get the code with git ###
You should switch to your apache user or the web user for your domain. 
```
sudo -s -u www-data
```

And go to the correct directory. 

To download the source code please execute 
```
git clone https://github.com/lordzeroMS/doctag.git .
``` 

### Prepare config ###
As last step adapt config-dist.php and save it with the name config.php 