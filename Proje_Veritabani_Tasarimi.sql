use Donem_Projesi__Cevrimici_Yemek_Siparis_Platformu_Veritabani_Tasarimi -- ilgili veritabanını seçiyoruz.

go

create table Musteri  -- tablo luşturma kısmı. 
(
	MusteriID int primary key identity (1,1), --muşteri id si olacak. pk yani benzersiz olacak ve id otomatik 1'er artacak
	Adi nvarchar (50) not null, -- müşteri adı olacak ve en fazla 50 karakter olacak ve boş bırakılamayacak
	Soyadi nvarchar(50) not null, -- müşteri soyadı olacak ve en fazla 50 karakter olacak ve boş bırakılamayacak
	Email nvarchar(100) unique not null, --mail adresi olacak boş olamayacak ve sütunda o mail bir defa tek kullanılabilecek
	Telefon nvarchar(15) unique not null, --telefon numarasıda olmak zorunda ve o da tek bir defa olacak.
	IsActive bit default 1, -- ilgili veriyi tablodan silmek yerine sadece aktiflik durumu belirtilecek.
)

select *from Musteri

create table Adresler
(
	AdresID int primary key identity (1,1),
	MusteriID int not null, 
	AdresDetay nvarchar(250) not null,

	foreign key(MusteriID) references Musteri(MusteriID), --bir müşterinin 1 den fazla adresi olabilir bu yüzden musteri
	-- tablosundaki musteriid ile adresler tablosundaki musteriid arasında foreign key ilişkisi kuruluyor. 

)

select *from Adresler


insert into Musteri(Adi,Soyadi,Email,Telefon)
values('Arafat','Çoban','arafatcoban@gmail.com','5315430789')
insert into Musteri(Adi,Soyadi,Email,Telefon,IsActive)
values('Ozan', 'Çoban', 'ozancoban@gmail.com', '00000000000')
insert into Musteri(Adi,Soyadi,Email,Telefon)
values('Devran', 'Çoban', 'devrancoban@gmail.com', '11111111111')
-- birden çok değer ekleyeceksem insert intoyu biz kez yazmam yeterli olacaktır. values diyerek yeni verileri ekleyebilirim
select *from Musteri

insert into Adresler(MusteriID,AdresDetay)
values(1, 'Van tuşba yüzüncü yıl üniversitesi')
insert into Adresler(MusteriID, AdresDetay)
values (2, 'Muş Bulanık')
insert into Adresler(MusteriID,AdresDetay)
values(3, 'istanbul ')
select *from Adresler


DROP TABLE Menu_Urunler; -- YANLIŞ VERİ EKLEDİĞİM İÇİN TABLOLARI SİLİP YENİDEN OLUŞTURACAĞIM.
drop table Kategoriler;
drop table Restoranlar;

CREATE TABLE Kategoriler -- kategoriler tablosu
(
	KategoriID int primary key identity(1,1),
	KategoriAdi nvarchar(50) not null unique,
	IsActive bit default 1,
)

CREATE TABLE Restoranlar -- restoranlar kategorisi
( 
	RestoranID int primary key identity (1,1),
	RestoranAdi nvarchar(100) not null,
	TelefonNo nvarchar(11) not null unique,
	RestoranPuani decimal (2,1) check (RestoranPuani between 1 and 5),
	ToplamCiro decimal(18,2) default 0,
	IsActive bit default 1
)

CREATE TABLE Menu_Urunler  -- menü yani ürünlerin olduğu kategori
(
	UrunID int primary key identity (1,1),
	RestoranID int not null,
	KategoriID int not null,
	UrunAdi nvarchar(50) not null,
	UrunAciklamasi nvarchar(200),
	Fiyat decimal(18,2) not null check (Fiyat > 0),
	IsActive bit default 1,

	constraint FK_Urun_Restoran foreign key (RestoranID) references Restoranlar(RestoranID), -- buradaki restoranıd restoranlar tablosundaki restoranıd den referans alıyor
	constraint FK_Urun_Kategori foreign key (KategoriID) references Kategoriler(KategoriID) -- buradaki kategoriıd kategoriler tablosundaki kategoriıd den referans alıyor
)

-- kategorileri ekliyoruz
INSERT INTO Kategoriler (KategoriAdi) VALUES ('Kebaplar'), ('Tatlılar'), ('İçecekler');

-- restoranları ekliyoruz
INSERT INTO Restoranlar (RestoranAdi, TelefonNo, RestoranPuani) 
VALUES 
('Kebapçım', '02121112233', 4.5),
('Tatlı Dünyası', '02124445566', 3.8);

-- ürünleri ekliyoruz (farklı restoran ve kategorilere dağıtıyoruz)
INSERT INTO Menu_Urunler (RestoranID, KategoriID, UrunAdi, UrunAciklamasi, Fiyat)
VALUES 
(1, 1, 'Adana Kebap', 'zırh kıymasıyla özel lezzet', 230.00), -- Kebapçım'da Kebap
(1, 3, 'Ayran', 'bol köpüklü', 35.00),                     -- Kebapçım'da İçecek
(2, 2, 'Fıstıklı Baklava', 'antep fıstıklı', 180.00);      -- Tatlı Dünyası'nda Tatlı

select * from Kategoriler
select * from Menu_Urunler
select * from Restoranlar  
