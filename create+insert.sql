GO 
USE master
GO

DROP DATABASE IF EXISTS JP_Keyboard 

GO
CREATE DATABASE JP_Keyboard
GO
USE JP_Keyboard
GO 





--CREATE TABLE 

CREATE TABLE ProductType(
	ProductTypeId INT PRIMARY KEY IDENTITY(1,1),
	ProductTypeName VARCHAR(100) CHECK(LEN(ProductTypeName)>0) NOT NULL
)


CREATE TABLE Product(
	ProductId INT PRIMARY KEY IDENTITY(1,1),
	ProductName VARCHAR(80) CHECK(LEN(ProductName)>0) NOT NULL,
	ProductPrice INT CHECK(ProductPrice>0) NOT NULL,  
	ProductStock INT NOT NULL,
	ProductWeight FLOAT NOT NULL,
	ProductDescription VARCHAR(200) CHECK(LEN(ProductDescription)>0) NOT NULL,
	ProductTypeId INT FOREIGN KEY REFERENCES ProductType(ProductTypeId) ON UPDATE CASCADE ON DELETE CASCADE
)


CREATE TABLE Staff(
	StaffId INT PRIMARY KEY IDENTITY(1,1),
	StaffName VARCHAR(80) CHECK(LEN(StaffName)>0) NOT NULL,
	StaffGender VARCHAR(8) CHECK(StaffGender='Male' OR StaffGender='Female') NOT NULL, 
	StaffSalary INT CHECK(StaffSalary>1000000) NOT NULL,
	StaffDOB DATE NOT NULL
)



CREATE TABLE Technician(
	TechnicianId INT PRIMARY KEY IDENTITY(1,1),
	TechnicianName VARCHAR(80) CHECK(LEN(TechnicianName)>0) NOT NULL,
	TechnicianGender VARCHAR(8) CHECK(TechnicianGender='Male' OR TechnicianGender='Female') NOT NULL, 
	TechnicianDOB DATE NOT NULL
)


CREATE TABLE Customer(
	CustomerId INT PRIMARY KEY IDENTITY(1,1), 
	CustomerName VARCHAR(80) CHECK(LEN(CustomerName)>0) NOT NULL,
	CustomerEmail VARCHAR(100) CHECK(LEN(CustomerEmail)>0) NOT NULL,
	CustomerDOB DATE NOT NULL CHECK(LEN(CustomerDOB)>0),
	CustomerGender VARCHAR(8) NOT NULL CHECK(CustomerGender = 'Male' OR CustomerGender = 'Female')
)

CREATE TABLE [Service](
	ServiceId INT PRIMARY KEY IDENTITY(1,1), 
	ServiceName VARCHAR(80) CHECK(LEN(ServiceName)>0) NOT NULL,
	ServiceDescription VARCHAR(200) CHECK(LEN(ServiceDescription)>0) NOT NULL,
	ServiceBasePrice INT CHECK(ServiceBasePrice>0) NOT NULL
)

CREATE TABLE [Address](
	AddressId INT PRIMARY KEY IDENTITY(1,1),
	CustomerId INT FOREIGN KEY REFERENCES Customer(CustomerId) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL ,
	AddressName VARCHAR(80) CHECK(LEN(AddressName)>0) NOT NULL,
	StreetName VARCHAR(200) CHECK(LEN(StreetName)>0) NOT NULL,
	City VARCHAR(100) CHECK(LEN(City)>0) NOT NULL,
	Country VARCHAR(80) CHECK(LEN(Country)>0) NOT NULL
)

CREATE TABLE ProductTransaction(
	ProductTransactionId INT PRIMARY KEY IDENTITY(1,1), 
	CustomerId INT FOREIGN KEY REFERENCES Customer(CustomerId) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	StaffId INT FOREIGN KEY REFERENCES Staff(StaffId) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	ProductTransactionDate DATE NOT NULL
)


CREATE TABLE ProductTransactionDetail(
	ProductTransactionId INT FOREIGN KEY REFERENCES ProductTransaction(ProductTransactionId) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	ProductId INT FOREIGN KEY REFERENCES Product(ProductId) NOT NULL ,
	Qty INT CHECK(Qty>0) NOT NULL,
	PRIMARY KEY(ProductId, ProductTransactionId)
)

CREATE TABLE ServiceTransaction(
	ServiceTransactionId INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	CustomerId INT FOREIGN KEY REFERENCES Customer(CustomerId) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TechnicianId INT FOREIGN KEY REFERENCES Technician(TechnicianId) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	ServiceTransactionDate DATE NOT NULL
)


CREATE TABLE ServiceTransactionDetail(
	ServiceTransactionId INT FOREIGN KEY REFERENCES ServiceTransaction(ServiceTransactionId) ON UPDATE CASCADE ON DELETE CASCADE,
	ServiceId INT FOREIGN KEY REFERENCES [Service](ServiceId) ON UPDATE CASCADE ON DELETE CASCADE,
	Qty INT CHECK(Qty>0) NOT NULL,
	ServiceTransactionDescription VARCHAR(200) NOT NULL,
	ServiceAdditionalPrice INT CHECK(ServiceAdditionalPrice>=0) NOT NULL,
	PRIMARY KEY (ServiceId, ServiceTransactionId)
)



INSERT INTO ProductType VALUES 
('Keyboard'),
('Switch'),
('Case'),
('Keycaps')



INSERT INTO Customer VALUES
('Vincent Benedict','vn@gmail.com','2001-11-21','Male'),
('Brandon Julio Thenaro','br@gmail.com','2001-06-07','Male'),
('Clarissa Chuardi','cc@gmail.com','2001-08-26','Female'),
('Skolastika Gabriella Theresendia Prasetyo','ga@gmail.com','2001-01-27','Female'),
('Johanes Peter Vincentius','jp@gmail.com','2001-04-03','Male'),
('Lim Lionel Ritchie','ll@gmail.com','2001-02-25','Male'),
('Stanley Dave Teherag','st@gmail.com','2001-8-12','Male'),
('Thaddeus Cleo','tc@gmail.com','2001-12-22','Male')



INSERT INTO Product VALUES
('Rexus Daxa M71 Pro',800000,20, 1,'Rexus keyboard with 65% layout that features backlit with full RGB and features hotswappable',1),
('Keychron K8',1500000,20, 1.6,'Keychron keyboard with TKL layout that features backlit with full RGB and features hotswappable',1),
('Ajazz K870t',800000,20, 1.2,'Ajazz keyboard with TKL layout that features backlit with full RGB and rollable volume changer',1),
('ObinsLab Anne Pro 2',1200000,20, 0.8,'Obins lab keyboard with 60% layout that features backlit with full RGB and unique RGB mods.',1),
('Custom acrylic sandwich case',225000,20, 0.4,'Custom case made from acrylic, with layers of acrylic, nailed into one sandwich case.',3),
('Gateron Yellow Pre lubed + Filmed Switch',5500,2000, 0.01,'Lubed and filmed gateron yellow switch (linear 50cN), this switch produces buttery sound and feel and this switch is more stable due too it being filmed.',2),
('Ducky One 2 SF',1500000,2000, 1.8,'Ducky keyboard with 65% layout that features backlit with very shiny RGB, strong firmware, unique customizable RGB and have a mini game in it',1),
('Gateron Red Switch',3500,2000, 0.01, 'Gateron linear switch with 45cN actuation force',2),
('Gateron Blue Switch',3500,2000, 0.01, 'Gateron clicky switch with 60cN actuation force',2),
('Gateron Brown Switch',3500,2000, 0.01, 'Gateron tactile switch with 55cN actuation force',2),
('Gateron Black Switch',3500,2000, 0.0, 'Gateron linear switch with 60cN actuation force',2),
('Cherry MX Silver Switch',3500,2000, 0.01, 'Cherry linear switch with 45cN actuation force',2),
('Cherry MX Brown Switch',3500,2000, 0.01, 'Cherry tactile switch with 55cN actuation force',2),
('Cherry MX Blue Switch',3500,2000, 0.01, 'Cherry linear switch with 60cN actuation force',2),
('Cherry MX Red Switch',3500,2000, 0.01, 'Cherry linear switch with 45cN actuation force',2),
('Cherry MX Green Switch',3500,2000, 0.01, 'Cherry clicky switch with 80cN actuation force',2),
('Kailh Box Navy',3500,2000, 0.01, 'Kailh clicky switch with 75cN actuation force',2),
('Kailh Box Jade',3500,2000, 0.01, 'Kailh clicky switch with 65cN actuation force',2),
('Kailh Box Dark Yellow',3500,2000, 0.01, 'Kailh linear switch with 70cN actuation force',2),
('Kailh Box Red',14000,2000, 0.01, 'Kailh linear switch with 50cN actuation force',2),
('Glorious Panda Switch',11500,2000, 0.01, 'Switch with 67cN actuation force',2),
('Razer BlackWidow V3 TKL',1500000,2000, 1.8, 'Razer keyboard with TKL layout that features backlit with full RGB ',1),
('PSONE KEYCAPS',399000,10, 0.2, 'PressPlay keycaps with psone theme, pbt dyesub, oem profile',4),
('XDA Ukiyo Keycaps',399000,10, 0.2, 'Ukiyo keycaps with seawaves theme, pbt dyesub, xda profile',4),
('Space 65',5695026,20, 1,'A premium keyboard with 65% layout which features alumunium plate and no switch is visible through this keyboard', 1)






INSERT INTO Staff VALUES 
('Niko Sidartha','Male',6000000,'2003-02-08'),
('Julieta','Female',6000000,'2002-07-10'),
('Kristo', 'Male', 4891701, '2021/04/24'),
('Axel', 'Female', 5591997, '2021/04/08'),
('Andree Benaya Abyatar ', 'Male', 5133344, '2020/12/29'),
('Blakeley', 'Male', 5377280, '2021/02/27'),
('Jacquelynn', 'Female', 5994127, '2020/08/29'),
('Flory', 'Female', 4894275, '2020/08/25'),
('Bengt', 'Female', 4233368, '2020/12/08'),
('Haleigh', 'Female', 5979036, '2021/01/10'),
('Hort', 'Female', 4416371, '2020/10/04'),
('Glen', 'Female', 4157872, '2020/10/08'),
('Chelsea', 'Female', 4082596, '2021/04/01'),
('Lim Thaddeus Dave', 'Male', 5081323, '2020/12/07'),
('Kingsley', 'Male', 4168537, '2020/08/02'),
('Reagan', 'Female', 5508900, '2021/02/14'),
('Raynell', 'Male', 4927757, '2020/07/16'),
('Carlene', 'Female', 5039767, '2021/04/01'),
('Philly', 'Female', 4884567, '2021/05/10'),
('Chev', 'Male', 4883289, '2020/12/16'),
('Marylee', 'Male', 4649161, '2020/07/23'),
('Christabella', 'Female', 4597941, '2020/10/16'),
('Linoel', 'Male', 4210055, '2020/07/08'),
('Rick', 'Female', 5702414, '2020/07/04'),
('Arlan', 'Male', 5977499, '2021/05/02'),
('Cristina', 'Male', 4196470, '2021/04/01'),
('Alyosha', 'Male', 5296280, '2021/01/17'),
('Nata', 'Female', 5708373, '2020/06/22'),
('Nanine', 'Female', 5207865, '2020/10/19'),
('Michele', 'Female', 5077617, '2021/01/14'),
('Seka', 'Female', 4211947, '2020/06/06')


INSERT INTO Technician VALUES 
('Jesslyn Abigail', 'Female', '2001/08/15'),
('Vigo Vigo', 'Male', '2002/09/19'),
('Micheal Krisna', 'Male', '1999/05/18'),
('Daniel Fujiono', 'Male', '2001/04/10'),
('Timmie', 'Female', '2001/05/04'),
('Grange', 'Male', '1995/04/09'),
('Karissa', 'Male', '2001/03/31'),
('Sheena', 'Female', '2001/05/15'),
('Inessa', 'Female', '1985/02/14'),
('Gertie', 'Female', '1998/08/20'),
('Ilyssa', 'Male', '1994/03/24'),
('Haven', 'Male', '1991/09/21'),
('Kort', 'Female', '1992/09/28'),
('Thorndike', 'Male', '1994/04/23'),
('Sibley', 'Male', '2000/10/13'),
('Nikolia', 'Male', '2001/04/15'),
('Ninon', 'Female', '2000/10/23'),
('Alejandro', 'Female', '2000/10/23'),
('Doretta', 'Female', '2000/09/03'),
('Franz', 'Female', '2000/07/08'),
('Donnie', 'Female', '2000/09/22'),
('Lorne', 'Female', '2000/06/22'),
('Avery', 'Male', '2004/07/18'),
('Idelle', 'Male', '2000/06/09'),
('Dean', 'Male', '2000/12/19'),
('Tobey', 'Male', '2000/07/11'),
('Romona', 'Male', '2000/09/21'),
('Rosella', 'Male', '2000/06/20'),
('May', 'Male', '2000/11/15'),
('Godfrey', 'Male', '2000/08/27'),
('Frederigo', 'Male', '2000/09/28'),
('Kendal', 'Male', '2001/03/12'),
('Sybyl', 'Female', '2000/09/30'),
('Grover', 'Female', '2001/04/09'),
('Creigh', 'Female', '2000/09/08'),
('Elisa', 'Male', '2001/01/14'),
('Angel', 'Male', '2001/04/20'),
('Cally', 'Female', '2001/04/13'),
('Drud', 'Female', '2000/10/19'),
('Raina', 'Female', '2001/04/09'),
('Jessa', 'Male', '2000/08/04'),
('Tory', 'Female', '2000/11/29'),
('Alleyn', 'Male', '2001/04/21'),
('Susann', 'Male', '2000/10/28'),
('Kalvin', 'Male', '2000/10/10'),
('Nissa', 'Male', '2001/04/01'),
('Dido', 'Female', '2001/03/04'),
('Josephina', 'Female', '2000/08/12'),
('Lilllie', 'Female', '2000/05/31'),
('Norine', 'Female', '2001/03/16'),
('Elaina', 'Female', '2000/08/13'),
('Olympie', 'Female', '1999/12/01'),
('Alyda', 'Male', '1998/07/29'),
('Ebba', 'Male', '1997/07/19')

GO

INSERT INTO ProductTransaction VALUES
(5,1,'2021-04-03'),
(7,1,'2021-04-03'),
(2,1,'2021-04-03'),
(3,1,'2021-04-03')
                   


INSERT INTO ProductTransactionDetail VALUES
(1,1, 1),
(1,5, 1),
(1,6, 72),
(1,7, 1),
(1,23, 1),
(1,24, 1),
(2,4, 1),
(3,2,1),
(3,22,1),
(4,3,1)







INSERT INTO [Service] VALUES
('Switch Lubing','Lube switch using krytox g205g',700),
('Switch Film installation','Install film to make switch more stable',600),
('Switch Film installation and Lubing','Film installation and lubing packet',1000),
('Stabilizer Lubing','Lube stabilizers with krytox and grease',10000),
('Desolder','Desolder your switch into your keyboard',1000),
('Solder','Solder your switch into your keyboard',1000),
('Solder and desoldering','Solder and desolder Packet',1800),
('Install Foam','Install foam into your keyboard to dampen its noise',2000),
('Change Case','Change your keyboard case',8000)





--



insert into Address (CustomerId, AddressName, StreetName, City, Country) values (5, 'Rumah', '702 Summer Ridge Court', 'Maracaçumé', 'Brazil');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (8, 'Rumah temen', '104 Springs Pass', 'Darband', 'Tajikistan');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (6, 'Rumah', '4 Beilfuss Place', 'Infanta', 'Philippines');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (7, 'Rumah temen', '91 Carey Junction', 'Qarqīn', 'Afghanistan');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (3, 'Kantor', '48 Weeping Birch Parkway', 'Al Mālikīyah', 'Syria');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (5, 'Rumah', '31103 Southridge Place', 'El Cobre', 'Venezuela');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (7, 'Kantor', '09126 Park Meadow Park', 'Złoty Stok', 'Poland');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (1, 'Rumah temen', '1909 Mayer Avenue', 'Rumbek', 'South Sudan');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (3, 'Rumah', '53 Sherman Road', 'Jifarong', 'Gambia');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (3, 'Kantor', '508 Crownhardt Junction', 'Xinjie', 'China');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (6, 'Rumah temen', '723 Shasta Drive', 'Fangbu', 'China');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (4, 'Kantor', '96 Merrick Court', 'Dióni', 'Greece');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (1, 'Kantor', '476 Eggendart Hill', 'Namerikawa', 'Japan');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (5, 'Rumah', '4 Merry Hill', 'Despotovac', 'Serbia');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (3, 'Kantor', '231 Warner Alley', 'Cabrela', 'Portugal');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (8, 'Rumah', '5 Kinsman Pass', 'Huurch', 'Mongolia');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (2, 'Kantor', '14663 Reinke Crossing', 'Rungis', 'France');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (6, 'Kantor', '4 Farragut Crossing', 'Tonggu', 'China');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (7, 'Rumah temen', '979 New Castle Terrace', 'Jonava', 'Lithuania');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (7, 'Rumah temen', '3082 Eagle Crest Lane', 'Fubin', 'China');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (4, 'Rumah', '113 Harper Road', 'Shichuan', 'China');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (8, 'Rumah', '210 Bartillon Park', 'Galle', 'Sri Lanka');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (1, 'Rumah', '2 Kinsman Park', 'Martingança', 'Portugal');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (5, 'Kantor', '1392 Cascade Crossing', 'Yao', 'Japan');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (7, 'Rumah', '410 Dottie Parkway', 'Patarrá', 'Costa Rica');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (4, 'Rumah', '035 Elmside Drive', 'Ogden', 'United States');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (5, 'Rumah', '0125 Dayton Parkway', 'Strasbourg', 'France');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (4, 'Kantor', '5902 New Castle Drive', 'Baiba', 'China');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (7, 'Rumah', '240 Barby Avenue', 'Sovetskoye', 'Russia');
insert into Address (CustomerId, AddressName, StreetName, City, Country) values (6, 'Kantor', '814 Rigney Drive', 'Nkurenkuru', 'Namibia');




insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (6, 1, '2020/09/08');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (2, 2, '2021/01/06');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (3, 3, '2021/02/16');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (2, 4, '2020/11/10');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (2, 5, '2021/01/21');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (8, 6, '2020/08/18');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (4, 7, '2020/06/21');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (4, 8, '2021/03/02');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (7, 9, '2020/12/25');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (8, 10, '2021/03/27');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (8, 11, '2020/12/12');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (6, 12, '2020/09/18');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (7, 13, '2021/03/03');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (6, 14, '2020/09/12');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (6, 15, '2021/05/12');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (7, 16, '2020/08/26');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (4, 17, '2021/05/21');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (7, 18, '2020/09/24');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (2, 19, '2020/11/24');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (8, 20, '2020/10/30');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (8, 21, '2021/04/18');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (6, 22, '2020/11/15');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (3, 23, '2020/10/21');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (4, 24, '2020/09/10');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (7, 25, '2021/03/12');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (5, 26, '2020/12/29');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (7, 20, '2020/08/06');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (8, 28, '2020/05/26');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (6, 29, '2020/10/08');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (4, 30, '2020/08/06');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (6, 31, '2020/12/05');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (4, 1 , '2021/02/21');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (3, 2 , '2020/10/18');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (2, 3, '2021/02/12');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (3, 4, '2020/09/28');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (2, 5, '2021/04/13');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (7, 6, '2020/09/09');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (4, 7, '2021/05/17');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (2, 8, '2020/10/15');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (8, 9, '2021/03/05');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (9, 10, '2020/12/29');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (7, 11, '2021/02/24');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (7, 12, '2021/02/19');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (6, 13, '2020/10/19');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (6, 14, '2021/01/02');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (6, 15, '2021/02/23');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (7, 16, '2020/11/05');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (7, 17, '2021/02/12');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (6, 18, '2020/10/25');
insert into ProductTransaction (CustomerId, StaffId, ProductTransactionDate) values (3, 19, '2021/05/13')








insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (24, 20, 20);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (25, 18, 45)
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (45, 19, 32);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (41, 22, 60);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (43, 19, 1);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (9, 22, 96);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (16, 5, 93);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (35, 22, 97);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 18, 80);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (25, 10, 40);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (17, 3, 39);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (53, 16, 90);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (51, 4, 57);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (48, 9, 17);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (48, 11, 73);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (42, 8, 52);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (38, 20, 56);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (19, 5, 30);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 12, 60);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (26, 18, 101);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (15, 15, 10);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (5, 18, 72);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (40, 11, 22);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (3, 7, 87);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (33, 3, 33);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 16, 33);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (44, 13, 39);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (2, 22, 88);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (36, 1, 80);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 14, 24);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (6, 12, 12);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (40, 2, 69);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (16, 22, 13);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (6, 12, 71);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (42, 15, 69);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (12, 14, 7);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (25, 6, 28);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (48, 22, 67);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 10, 39);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (11, 13, 94);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (16, 21, 41);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (10, 19, 21);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (46, 6, 78);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (28, 9, 71);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (22, 10, 77);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (38, 14, 64);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (30, 13, 15);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (23, 1, 103);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (16, 8, 15);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (18, 12, 43);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (46, 2, 80);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (25, 8, 49);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (4, 16, 20);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (4, 7, 21);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (19, 12, 2);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (11, 18, 54);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 5, 39);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (49, 1, 1);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (36, 22, 7);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (46, 21, 79);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (16, 7, 89);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (13, 3, 90);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (2, 9, 65);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (25, 2, 48);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 8, 2);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (42, 14, 47);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 9, 11);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 15, 104);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (5, 20, 12);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (19, 15, 10);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (15, 9, 24);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (28, 13, 2);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (34, 3, 10);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (52, 6, 60);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (13, 17, 4);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (6, 20, 68);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 10, 48);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (53, 4, 7);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (30, 20, 11);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (20, 6, 10);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (16, 22, 83);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (51, 22, 3);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (38, 18, 54);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (8, 5, 15);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (19, 2, 88);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (50, 9, 26);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 3, 43);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (35, 8, 60);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 16, 34);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (5, 10, 22);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (47, 17, 14);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 13, 66);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (48, 13, 1);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (32, 2, 61);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (51, 5, 14);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (36, 11, 77);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (41, 10, 59);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (2, 9, 58);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (13, 22, 45);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (35, 13, 24);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (44, 1, 50);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (28, 17, 18);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 10, 74);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 3, 33);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (8, 18, 82);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (42, 10, 5);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (20, 11, 3);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (49, 2, 75);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (29, 5, 5);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (48, 9, 97);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (17, 8, 84);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (14, 11, 34);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (39, 3, 2);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (14, 2, 37);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (40, 4, 59);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (39, 1, 45);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 17, 74);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (41, 11, 49);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (36, 18, 51);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (32, 17, 8);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (29, 19, 11);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (19, 18, 104);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (39, 21, 20);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (4, 11, 94);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (8, 6, 40);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (10, 15, 33);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (28, 22, 84);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (28, 14, 40);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (38, 3, 20);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 18, 22);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 15, 103);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (29, 11, 56);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (51, 21, 33);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (2, 13, 18);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (39, 4, 9);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (16, 19, 78);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 2, 46);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (10, 1, 48);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (29, 10, 51);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (21, 11, 19);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 4, 95);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (17, 4, 51);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (42, 22, 25);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (49, 13, 40);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (11, 8, 90);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (33, 18, 63);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (44, 12, 44);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (38, 18, 15);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (23, 15, 101);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (28, 22, 8);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 16, 89);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (38, 12, 35);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (15, 12, 101);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (30, 4, 15);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (23, 8, 92);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (8, 15, 35);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (46, 18, 46);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (6, 5, 100);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (14, 18, 2);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 2, 59);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (38, 15, 90);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (32, 14, 51);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (24, 9, 5);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (20, 21, 66);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (42, 15, 2);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (23, 14, 72);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (16, 5, 13);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (45, 22, 69);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (2, 12, 44);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (34, 2, 95);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (4, 19, 43);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (19, 16, 53);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (4, 22, 25);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (5, 12, 4);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 10, 90);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (40, 20, 53);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (20, 11, 25);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (9, 3, 12);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (14, 14, 15);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 20, 7);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (17, 1, 95);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (32, 16, 68);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (21, 15, 21);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (28, 6, 74);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (19, 22, 18);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (39, 22, 51);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (28, 5, 82);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (20, 16, 86);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 4, 103);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (21, 12, 54);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (33, 16, 4);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (41, 14, 29);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (44, 13, 97);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (12, 16, 62);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (46, 15, 17);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (42, 5, 56);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (33, 4, 85);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (24, 18, 48);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (45, 9, 14);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (50, 8, 16);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (11, 1, 57);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 14, 70);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (49, 12, 63);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (10, 4, 24);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (29, 16, 13);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 11, 24);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (29, 10, 60);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (16, 22, 81);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (10, 22, 55);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 8, 67);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (6, 13, 33);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (46, 12, 44);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (26, 4, 21);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (35, 18, 92);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (41, 3, 66);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (42, 7, 8);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (12, 1, 92);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (50, 15, 46);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (38, 2, 54);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (19, 16, 43);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (46, 19, 64);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (25, 9, 30);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (26, 4, 70);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (43, 1, 27);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (17, 20, 26);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (50, 7, 54);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (4, 4, 79);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (13, 13, 98);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (23, 8, 49);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (20, 8, 10);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (12, 13, 37);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (37, 17, 28);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (50, 19, 10);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (4, 1, 30);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (25, 10, 36);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 6, 31);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (23, 18, 21);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (23, 4, 60);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (21, 9, 58);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (43, 17, 80);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (46, 7, 76);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 21, 32);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (10, 14, 79);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (33, 22, 11);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (6, 16, 100);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (12, 16, 98);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (38, 13, 7);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (14, 19, 25);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 4, 54);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 15, 19);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (44, 9, 65);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (45, 16, 63);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (51, 6, 18);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (6, 1, 94);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (48, 18, 75);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (49, 21, 44);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (30, 14, 35);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (16, 16, 67);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (40, 1, 21);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (6, 7, 32);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (33, 11, 31);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (7, 8, 75);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (14, 7, 89);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (33, 1, 25);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (30, 5, 22);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (22, 4, 32);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (34, 5, 21);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (46, 10, 94);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (31, 9, 28);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 14, 33);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (48, 11, 24);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (3, 7, 4);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (13, 1, 65);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (22, 16, 56);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (8, 7, 15);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (4, 6, 41);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (27, 6, 24);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (29, 9, 29);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (4, 11, 60);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (40, 14, 76);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (9, 10, 85);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (21, 3, 68);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (35, 20, 83);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (38, 17, 42);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (17, 9, 18);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (21, 17, 40);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (21, 4, 27);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (18, 10, 81);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (39, 11, 7);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (36, 3, 95);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (20, 18, 43);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (2, 18, 36);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (24, 17, 45);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (43, 9, 71);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (6, 11, 82);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (53, 21, 23);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (35, 17, 69);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (54, 17, 63);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (51, 6, 1);
insert into ProductTransactionDetail (ProductTransactionId, ProductId, Qty) values (11, 4, 5);




insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (7, 1, '2020/09/03');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (1, 2, '2021/03/22');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (2, 3, '2021/01/20');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (3, 4, '2021/01/10');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (4, 5, '2020/09/06');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (5, 6, '2021/02/05');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (5, 7, '2020/08/31');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (7, 8, '2020/10/12');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (2, 9, '2020/11/18');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (7, 10, '2021/03/04');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (8, 11, '2020/09/20');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (7, 12, '2020/09/25');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (4, 13, '2021/05/01');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (7, 14, '2021/04/19');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (4, 15, '2020/07/11');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (8, 16, '2020/10/05');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (8, 17, '2020/07/12');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (5, 18, '2020/11/21');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (5, 19, '2021/03/08');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (4, 20, '2021/01/15');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (4, 21, '2020/06/06');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (1, 22, '2020/07/02');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (5, 23, '2020/12/27');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (4, 24, '2020/12/21');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (5, 25, '2020/09/26');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (2, 26, '2021/03/11');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (5, 27, '2021/02/13');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (4, 28,  '2020/11/28');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (4, 29, '2021/05/01');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (3, 30, '2020/07/30');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (1, 31, '2021/03/25');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (7, 32, '2021/04/04');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (1, 33, '2021/02/10');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (3, 34, '2020/11/08');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (4, 35, '2020/09/24');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (2, 36, '2021/01/06');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (3, 37, '2020/12/14');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (8, 38, '2020/12/03');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (7, 39, '2020/05/22');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (1, 40, '2020/11/07');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (2, 41, '2020/10/16');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (4, 42, '2020/12/03');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (5, 43, '2020/09/03');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (7, 44, '2021/01/02');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (8, 45, '2020/05/22');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (5, 46, '2020/11/16');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (8, 47, '2020/09/27');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (3, 48, '2020/09/08');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (3, 49, '2020/12/27');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (7, 50, '2021/01/14');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (3, 51, '2020/05/31');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (8, 53, '2020/08/10');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (3, 54, '2020/09/22');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (3, 1, '2020/09/30');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (4, 3, '2020/08/10');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (2, 4, '2021/05/23');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (5, 4, '2021/03/09');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (1, 2, '2021/05/16');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (8, 1, '2020/08/05');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (2, 5, '2021/03/27');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (8, 2, '2020/10/06');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (3, 4, '2021/03/26');
insert into ServiceTransaction (CustomerId, TechnicianId, ServiceTransactionDate) values (1, 3, '2020/07/08');


insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (36, 1, 26, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (3, 6, 31, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (39, 4, 52, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (63, 8, 84, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (15, 1, 72, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (42, 3, 41, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (57, 8, 57, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (58, 4, 11, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (2, 4, 84, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (1, 6, 32, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (52, 2, 24, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (18, 6, 3, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (25, 3, 31, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (47, 5, 104, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (20, 3, 34, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (12, 2, 15, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (61, 2, 55, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (46, 2, 85, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (24, 8, 8, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (51, 5, 94, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (56, 8, 87, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (37, 9, 34, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (58, 2, 2, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (8, 2, 62, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (21, 4, 85, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (20, 7, 66, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (34, 4, 83, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (42, 2, 97, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (34, 1, 94, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (28, 1, 72, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (11, 8, 20, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (17, 9, 73, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (22, 6, 18, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (54, 5, 93, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (62, 8, 20, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (45, 9, 85, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (39, 4, 76, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (49, 3, 27, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (38, 7, 103, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (44, 7, 25, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (17, 6, 44, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (54, 9, 77, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (15, 3, 39, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (47, 1, 52, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (27, 6, 48, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (60, 9, 77, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (34, 4, 61, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (46, 3, 59, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (26, 3, 48, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (14, 5, 26, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (30, 3, 54, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (44, 9, 7, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (32, 2, 99, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (5, 5, 19, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (24, 1, 14, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (57, 4, 66, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (60, 4, 94, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (49, 2, 6, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (56, 7, 39, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (56, 9, 55, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (25, 1, 87, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (59, 1, 23, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (7, 2, 81, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (9, 2, 18, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (57, 8, 20, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (31, 5, 101, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (36, 4, 15, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (31, 2, 41, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (17, 4, 34, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (32, 3, 104, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (28, 1, 90, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (15, 4, 15, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (4, 9, 5, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (9, 2, 88, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (58, 5, 55, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (53, 7, 53, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (42, 6, 37, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (36, 3, 16, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (43, 3, 17, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (33, 9, 61, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (37, 6, 81, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (15, 4, 1, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (6, 5, 50, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (56, 4, 74, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (21, 8, 44, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (3, 3, 34, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (20, 4, 87, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (52, 6, 40, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (31, 3, 87, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (52, 5, 76, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (29, 6, 13, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (17, 1, 61, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (39, 3, 21, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (59, 3, 4, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (57, 5, 104, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (24, 7, 48, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (40, 2, 55, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (9, 6, 78, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (18, 6, 102, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (8, 5, 34, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (50, 8, 41, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (24, 9, 59, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (58, 9, 81, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (59, 4, 44, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (59, 3, 26, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (63, 1, 74, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (39, 4, 26, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (35, 2, 53, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (1, 3, 89, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (30, 9, 36, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (52, 6, 46, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (48, 7, 5, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (34, 7, 77, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (43, 3, 26, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (41, 4, 61, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (17, 2, 38, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (53, 9, 66, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (29, 3, 92, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (4, 3, 55, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (61, 2, 42, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (55, 1, 88, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (46, 5, 51, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (48, 9, 102, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (39, 8, 73, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (21, 1, 90, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (41, 7, 33, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (55, 3, 89, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (39, 5, 89, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (47, 9, 11, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (17, 2, 61, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (16, 5, 36, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (58, 8, 36, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (11, 4, 88, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (53, 8, 77, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (10, 1, 13, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (10, 1, 22, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (42, 7, 101, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (14, 3, 11, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (50, 6, 49, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (36, 3, 62, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (63, 5, 99, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (50, 3, 7, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (17, 2, 102, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (62, 7, 75, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (36, 9, 22, 'no description', 0);

insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (56, 9, 63, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (35, 8, 44, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (7, 6, 102, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (34, 1, 7, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (53, 1, 23, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (6, 7, 30, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (9, 7, 16, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (7, 3, 34, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (40, 1, 66, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (17, 5, 31, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (40, 7, 16, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (59, 8, 57, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (47, 5, 59, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (5, 6, 94, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (47, 2, 71, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (1, 4, 54, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (57, 6, 104, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (58, 9, 37, 'no description', 0);

insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (41, 5, 22, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (45, 3, 87, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (22, 5, 5, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (9, 9, 70, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (22, 3, 27, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (47, 5, 56, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (27, 2, 65, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (39, 5, 103, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (58, 6, 23, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (38, 5, 99, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (8, 1, 19, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (62, 7, 36, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (26, 8, 61, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (32, 3, 71, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (37, 1, 52, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (59, 8, 42, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (27, 6, 46, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (20, 2, 33, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (9, 1, 103, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (13, 5, 42, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (53, 1, 19, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (53, 3, 81, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (16, 5, 85, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (24, 7, 56, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (39, 1, 88, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (50, 2, 21, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (28, 6, 18, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (8, 8, 101, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (47, 6, 24, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (31, 2, 4, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (40, 6, 92, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (38, 8, 35, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (21, 2, 1, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (14, 3, 11, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (40, 3, 62, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (7, 7, 70, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (62, 5, 99, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (23, 2, 74, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (2, 7, 69, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (44, 2, 76, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (30, 8, 59, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (53, 2, 41, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (26, 2, 12, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (48, 4, 62, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (1, 9, 32, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (57, 2, 70, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (29, 8, 20, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (42, 9, 48, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (43, 5, 61, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (47, 4, 75, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (28, 3, 8, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (42, 6, 87, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (42, 6, 36, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (26, 5, 33, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (38, 6, 2, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (36, 3, 33, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (39, 2, 15, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (31, 2, 7, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (28, 9, 26, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (61, 3, 91, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (20, 9, 81, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (59, 1, 77, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (11, 7, 93, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (44, 8, 31, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (28, 9, 56, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (5, 6, 66, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (27, 7, 36, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (13, 2, 76, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (22, 5, 43, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (52, 7, 22, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (2, 7, 32, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (43, 9, 22, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (14, 1, 99, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (28, 3, 55, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (5, 3, 61, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (62, 5, 77, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (26, 5, 11, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (61, 1, 73, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (51, 5, 34, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (47, 2, 102, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (46, 9, 59, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (38, 5, 48, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (31, 2, 95, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (39, 8, 13, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (32, 9, 84, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (57, 7, 10, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (2, 1, 93, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (7, 9, 43, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (40, 6, 59, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (18, 7, 89, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (50, 5, 73, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (10, 4, 62, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (40, 3, 76, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (22, 5, 104, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (38, 3, 19, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (19, 7, 6, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (12, 8, 48, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (3, 1, 38, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (43, 6, 21, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (23, 1, 24, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (21, 7, 15, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (8, 4, 91, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (24, 2, 16, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (19, 2, 34, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (25, 6, 37, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (41, 3, 74, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (8, 1, 44, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (2, 6, 90, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (17, 3, 12, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (46, 7, 67, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (47, 3, 34, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (51, 4, 22, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (39, 6, 54, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (27, 1, 15, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (16, 1, 49, 'no description', 0);

insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (10, 7, 28, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (23, 8, 34, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (56, 1, 94, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (14, 4, 40, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (38, 4, 57, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (49, 8, 73, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (30, 6, 4, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (59, 6, 20, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (62, 9, 82, 'no description', 0);
insert into ServiceTransactionDetail (ServiceTransactionId, ServiceId, Qty, ServiceTransactionDescription, ServiceAdditionalPrice) values (29, 7, 20, 'no description', 0);




SELECT * FROM Product
SELECT * FROM ProductType
SELECT * FROM ProductTransaction

INSERT INTO Product VALUES('Shirakawa Keycaps',419000, 30, 0.2, 'Shirkawa pbt dye sub keycaps with japanese root printed on it',4)
INSERT INTO ProductTransaction VALUES(5,1, '2021/06/14')
INSERT INTO ProductTransactionDetail VALUES(55, 26, 1)
INSERT INTO ProductTransactionDetail VALUES(55, 6, 68)

INSERT INTO ServiceTransaction VALUES(5, 2, '2021/06/14')

INSERT INTO ServiceTransactionDetail VALUES(64,7, 67,'No Description',0) 
INSERT INTO ServiceTransactionDetail VALUES(64,4, 5,'Opening the keyboard case took some time',4000) 
INSERT INTO ServiceTransactionDetail VALUES(64,8, 5,'No Description',0) 





CREATE TYPE ScannedProductsTable AS TABLE(ProductId INT, qty INT);

