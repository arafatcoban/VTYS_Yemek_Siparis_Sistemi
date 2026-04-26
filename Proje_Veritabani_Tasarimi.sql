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

-- 27 Nisan...
create table Kuryeler
(
	KuryeID int primary key identity(1,1),
	Ad nvarchar(50) not null,
	Soyad nvarchar(50) not null,
	TelefonNo nvarchar(11) not null unique,
	Durum bit default 1, -- 1 olması müsait olduğu anlamına geliyor 0 olsa meşguldür. 
	IsActive bit default 1
)

select * from Kuryeler

create table Siparisler
(
	SiparisID int primary key identity(1,1),
	MusteriID int not null,
	RestoranID int not null,
	KuryeID int not null,
	SİparisDurumu nvarchar default 'Hazırlanıyor',-- üç durum olabilir: hazırlanıyor, yolda, teslim edildi. ilk sisteme düştüğünde hazırlanıyor olarak görünür.
	ToplamTutar decimal(18,2),
	SiparisTarihi datetime default getdate(), -- tarih olarak o anki tarih alınmaktadır getdate fonksiyonu sayesinde 

	IsAskidaSiparis bit default 0, -- 1 olması bu siparişin askıda yemek uygulaması kapsamında karşılandığı anlamına gelir. 
	BagisTutari decimal(18,2), -- insanların sipariş verirken eğer bağışta bulunmak isterlerse diye...
	

	constraint FK_Siparis_Musteri foreign key(MusteriID) references Musteri(MusteriID),
	constraint FK_Siparis_Restoran foreign key(RestoranID) references Restoranlar(RestoranID),
	constraint FK_Siparis_Kurye foreign key (KuryeID) references Kuryeler(KuryeID)
)

select *from Siparisler

create table Askida_Yemek_Kumbara
(
	KumbaraID int primary key identity(1,1),
	MevcutBakiye decimal(18,2) default 0, -- toplanan toplam bağış miktarı tutulmaktadır.
	SonGuncellemeTarihi datetime default getdate()
)

insert into Askida_Yemek_Kumbara(MevcutBakiye) values(0) -- 0 tl ekleyerek kumbarayı oluşturdum.

select *from Askida_Yemek_Kumbara

-- son 3 tablo şu mantıkla oluşturulmuştur: müşteri sipariş verirken BagisTutarisütunu karşısına gelir. eklediği toplam tutarda kumbaraya eklenir. 
-- eğer askıda sipariş uygulamasından sipariş verirse IsAskidaYemek 1 olur ve kimin askıda yemek aldığı belli olur. 
-- bu tablolar ve aralarındaki bağlantılar sayesinde kimin ne kadar bağış yaptığı kimin askıdan yemek aldığı kumbaradaki toplam tutar vs vs hepsi görünür.

create table Siparis_Detaylari
(
	SiparisDetayID int primary key identity(1,1),
	SiparisID int not null, -- hangi siparişe ait olduğunu belirlemek için
	UrunID int not null, -- siparişe hangi ürünlerin eklendiğini bilmek için
	Adet int not null check(Adet>0) -- müşterinin üründen kaç tane yediğini hatırlamak adına.
	BirimFiyat decimal(18,2) --Ürünün satış anındaki fiyatıdır; ürünün etiket fiyatı sonradan değişse bile geçmiş sipariş kayıtlarının bozulmamasını sağlar.

	constraint FK_SiparisDetayi_Siparis foreign key(SiparisID) references Siparisler(SiparisID),
	constraint FK_SiparisDetayi_Urun foreign key(UrunID) references Menu_Urunler(UrunID)
)
