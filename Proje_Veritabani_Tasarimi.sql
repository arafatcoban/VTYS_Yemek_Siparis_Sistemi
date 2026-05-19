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


insert into Kuryeler (Ad, Soyad, TelefonNo, Durum)
values ('Ahmet', 'Yılmaz', '05551112233', 1);
-- Durum 1: Müsait demek
-- kuryerler tablosunda IsActive kolonunu gereksiz olarak tanımlamışım şimdi onu sileceğim

-- alter table Kuryeler drop column IsActive; -- önce bunu denedim ama default değeri olduğu için direkt silinemiyormuş

alter table Kuryeler drop constraint DF_Kuryeler_IsActive; -- bu kod kısmını yapay zeka dan aldım. bunun sayesinde şuanda default değeri yok ilgili kolonun 

alter table Kuryeler drop column IsActive;

insert into Siparisler(MusteriID,RestoranID,KuryeID, ToplamTutar,IsAskidaSiparis,BagisTutari)
values(1,1,1, 250.00, 0, 20.00); -- askıda sipariş olmadığı için IsAskidaSiparis 0 olmalıdır. normal bir sipariş çünkü

alter table Siparisler -- siparisdurumu adlı kolonun uzunluğunu değiştirdim siparişin durumunu belirtmek için. 
alter column SİparisDurumu nvarchar(50); 

insert into Siparis_Detaylari(SiparisID, UrunID, Adet,BirimFiyat)
values (4,1,2,125.00) -- urun id si 1 olan adana kebaptı ve kebaptan 2 adet ekledim biirm fiyatı da 125 tl. 

update Siparis_Detaylari set BirimFiyat = 230 where  BirimFiyat = 115;
update Siparisler set ToplamTutar = 480 where ToplamTutar = 250

select *from Restoranlar

select *from Adresler

select *from Musteri

select *from Menu_Urunler

select *from Siparisler

select *from Siparis_Detaylari

select *from Kuryeler -- KONTROL AMAÇLI TÜM TABLOLARI ÇEKTİM BURADA.

-- TRİGGER YAZMA KISMI...

create trigger  TRG_BagisEkle -- yazacağım trigger a bir isim veriyorum
on Siparisler -- hangi tabloyu takip edeceğimizi belirliyoruz. yani burada siparişler tablosunu takip edeceğiz.
after insert -- ne zaman çalışacağını belirliyorum. mesela burada siparis tablosuna yeni siparis eklendiğinde buranın çalışacağını belirliyorum.
as
begin
	declare @GelenBagis decimal(18,2);
	select @GelenBagis = BagisTutari from inserted;-- yeni eklenen siparişteki bağış miktarını alıp bu değişkene atıyoruz

	if @GelenBagis > 0
	begin
		update Askida_Yemek_Kumbara
		set MevcutBakiye = MevcutBakiye + @GelenBagis
		where KumbaraID=1;
	end
end;


insert into Kuryeler (Ad, Soyad, TelefonNo, Durum)
values ('Ali', 'Veli', '05369852101', 1);

insert into Kuryeler(Ad,Soyad,TelefonNo,Durum)
values('Yasin', 'Durak', '02563546978', 1);

select *from Askida_Yemek_Kumbara

insert into Siparisler(MusteriID,RestoranID,KuryeID, ToplamTutar,IsAskidaSiparis,BagisTutari)
values(2, 2, 2, 250.00, 0, 70.00);

insert into Siparis_Detaylari(SiparisID,UrunID,Adet,BirimFiyat)
values(5,2,1,180);


-- 14 MAYIS. ÖNCEDEN EKLENEN VERİLERİ SİLİP BAŞTAN TEMİZ BİR ŞEKİLDE VERİ EKLEMEK İÇİN TÜM TABLOLARDA BULUNAN VERİLERİ SİLİYORUM.
-- 1. En alt katman (İlişkili tablolar)
TRUNCATE TABLE Siparis_Detaylari;
TRUNCATE TABLE Askida_Yemek_Kumbara;

-- 2. Orta katman
-- Siparisler tablosu FK ile bağlı olduğu için TRUNCATE yerine bunu kullanıyoruz:
DELETE FROM Siparisler;
DBCC CHECKIDENT ('Siparisler', RESEED, 0);

-- 3. Üst katman (Katalog tabloları) eğer 2 tablo arasında fk ilişkisi varsa önce referans alan silinir sonra da referans veren.
DELETE FROM Menu_Urunler;
DBCC CHECKIDENT ('Menu_Urunler', RESEED, 0);

DELETE FROM Restoranlar;
DBCC CHECKIDENT ('Restoranlar', RESEED, 0);

DELETE FROM Kuryeler;
DBCC CHECKIDENT ('Kuryeler', RESEED, 0);

DELETE FROM Musteri;
DBCC CHECKIDENT ('Musteri', RESEED, 0);

DELETE FROM Kategoriler;
DBCC CHECKIDENT ('Kategoriler', RESEED, 0);

delete from Adresler
dbcc checkident ('Adresler', reseed, 0)

-- şimdi de otomatik veri eklemek için bir trigger yazacağım. ama öncesinde her bir tabloya birer tane veriyi manuel olarak ekliyorum
--INSERT INTO Kategoriler (KategoriAdi) VALUES ('Kebaplar');
--INSERT INTO Musteri (Adi, Soyadi, Email, Telefon) VALUES ('Arafat', 'Çoban', 'arafat@mail.com', '5315430789');
INSERT INTO Restoranlar (RestoranAdi,TelefonNo, RestoranPuani) VALUES ('Van Sofrası','3265418924', 4);
INSERT INTO Kuryeler (Ad, Soyad, TelefonNo, Durum) VALUES ('Ali', 'Veli', '5550001122', 1);
INSERT INTO Menu_Urunler (RestoranID, KategoriID, UrunAdi, Fiyat) VALUES (2, 1, 'Adana Kebap', 250.00);

INSERT INTO Restoranlar (RestoranAdi, TelefonNo, RestoranPuani) VALUES -- restoranlar tablosuna veri ekliyorum. 
('Van Sofrası', '04321112233', 5),
('Göl Kenarı Balıkçısı', '04322223344', 4),
('Merkez Kebap Salonu', '04323334455', 5),
('Hacıoğlu Baklava', '04324445566', 3),
('Üniversite Kantini', '04325556677', 4);



select *from Menu_Urunler

DELETE FROM Menu_Urunler;
DBCC CHECKIDENT ('Menu_Urunler', RESEED, 0);
-- Eğer bu restorana bağlı ürün yoksa tık diye siler:
DELETE FROM Restoranlar WHERE RestoranID = 2;

INSERT INTO Restoranlar (RestoranAdi, TelefonNo, RestoranPuani, IsActive) 
VALUES ('Akdamar Kahvaltı Salonu', '04329998877', 5, 1);

INSERT INTO Menu_Urunler (RestoranID, KategoriID, UrunAdi, UrunAciklamasi, Fiyat, IsActive) VALUES 
(8, 1, 'Zırh Adana', 'Elde kıyılmış kuzu eti ve kök biberle hazırlanmış acılı kebap.', 280.00, 1),
(8, 1, 'Urfa Kebap', 'Acısız, yumuşak içimli kuzu kıyma kebabı.', 275.00, 1),
(7, 1, 'Kuzu Şiş', 'Süt kuzusundan marine edilmiş, lokum kıvamında şiş.', 320.00, 1),
(7, 1, 'Çöp Şiş', 'Kuzunun en yumuşak yerinden, bol kuyruk yağı eşliğinde.', 240.00, 1),
(3, 1, 'Beyti Sarma', 'Lavaş içinde kaşarlı kebap, özel sos ve yoğurtla.', 310.00, 1),
(3, 1, 'Ali Nazik', 'Sarımsaklı köz patlıcan yatağında kuzu kuşbaşı.', 340.00, 1),
(4, 1, 'Patlıcanlı Kebap', 'Gaziantep usulü, kemer patlıcan ve zırh eti uyumu.', 290.00, 1),
(4, 1, 'Fıstıklı Kebap', 'İçine taze Antep fıstığı karıştırılmış özel zırh kıyması.', 330.00, 1),
(5, 1, 'Tavuk Şiş', 'Özel sosla 24 saat marine edilmiş tavuk göğsü.', 190.00, 1),
(5, 1, 'Tavuk Kanat', 'Acılı sos ve kömür ateşinde çıtır kıvamda.', 180.00, 1),
(6, 1, 'Vali Kebabı', 'Karışık ızgara tabağı (Adana, Urfa, Şiş, Kanat).', 450.00, 1),
(6, 1, 'Kağıt Kebabı', 'Antakya usulü, sebze ve etin kağıtta pişmiş hali.', 260.00, 1),
(8, 1, 'Abugannuş', 'Közlenmiş sebzeler üzerinde servis edilen kuzu eti.', 300.00, 1),
(7, 1, 'İskender', 'Bursa usulü döner, tereyağlı pide ve özel domates sos.', 350.00, 1),
(3, 1, 'Kuzu Pirzola', 'Kekikle marine edilmiş 3 adet kalem pirzola.', 380.00, 1),
(4, 1, 'Haşhaş Kebabı', 'Birecik usulü bol sebzeli ve baharatlı zırh kebabı.', 285.00, 1),
(5, 1, 'Küşleme', 'Kuzunun en nadide parçası, sinirsiz ve yumuşak.', 420.00, 1),
(6, 1, 'Soğan Kebabı', 'Arpacık soğan ve nar ekşili özel kış kebabı.', 270.00, 1),
(8, 1, 'Ciğer Şiş', 'Günlük taze kuzu ciğeri, kimyon ve pul biberli.', 230.00, 1),
(7, 1, 'Sarma Beyti', 'Özel soslu lavaşa sarılı, üzerinde tereyağı ile.', 315.00, 1);

INSERT INTO Menu_Urunler (RestoranID, KategoriID, UrunAdi, UrunAciklamasi, Fiyat, IsActive) VALUES 
(8, 2, 'Antep Baklava', '40 kat ince yufka ve bol fıstıklı klasik lezzet.', 160.00, 1),
(8, 2, 'Havuç Dilimi', 'Sıcak servis edilen bol fıstıklı iri dilim baklava.', 180.00, 1),
(7, 2, 'Künefe', 'Hatay peynirli, sıcak şerbetli ve çıtır kadayıf.', 130.00, 1),
(7, 2, 'Billuriye', 'Bol fıstıklı, hafif şerbetli özel Antep tatlısı.', 150.00, 1),
(3, 2, 'Fırın Sütlaç', 'Hamsiköy usulü, üzeri yanık ve bol fındıklı.', 85.00, 1),
(3, 2, 'Kazandibi', 'Dib tutmuş sütlü tatlı, karamelize lezzet.', 90.00, 1),
(4, 2, 'Kemalpaşa', 'Tahin ve dövülmüş ceviz eşliğinde sunulur.', 75.00, 1),
(4, 2, 'Ekmek Kadayıfı', 'Afyon usulü, üzerine manda kaymağı eklenmiş.', 110.00, 1),
(5, 2, 'Trileçe', 'Karamel soslu ve üç çeşit sütle hazırlanan Balkan tatlısı.', 95.00, 1),
(5, 2, 'Supangle', 'Yoğun çikolatalı ve kek parçacıklı soğuk lezzet.', 80.00, 1),
(6, 2, 'Magnolia', 'Mevsim meyveleri ve bisküvi kırıntılı hafif krema.', 100.00, 1),
(6, 2, 'Kıbrıs Tatlısı', 'Galeta unlu kek ve muhallebi katmanlı hafif tatlı.', 90.00, 1),
(8, 2, 'Şöbiyet', 'İçinde kaymak ve bol fıstık bulunan muska dilim.', 170.00, 1),
(7, 2, 'Katmer', 'Kaymak ve fıstığın sıcak yufka ile buluşması.', 220.00, 1),
(3, 2, 'Kabak Tatlısı', 'Hatay usulü kireçte bekletilmiş, dışı çıtır içi yumuşak.', 120.00, 1),
(4, 2, 'İncir Uyutması', 'Kuru incir ve sütle hazırlanan geleneksel hafif tatlı.', 85.00, 1),
(5, 2, 'Halka Tatlısı', 'Sıcak ve şerbetli klasik sokak lezzeti.', 40.00, 1),
(6, 2, 'Ayva Tatlısı', 'Karanfilli şerbetle pişmiş, kaymaklı yarım ayva.', 115.00, 1),
(8, 2, 'Fıstık Sarma', 'Tamamen fıstık ezmesinden oluşan yoğun lezzet.', 210.00, 1),
(7, 2, 'Keşkül', 'Badem sütü ile hazırlanan Osmanlı usulü sütlü tatlı.', 85.00, 1);

INSERT INTO Menu_Urunler (RestoranID, KategoriID, UrunAdi, UrunAciklamasi, Fiyat, IsActive) VALUES 
(8, 3, 'Yayık Ayran', 'Bol köpüklü, doğal yoğurttan ve naneli.', 35.00, 1),
(7, 3, 'Şalgam Suyu', 'Adana usulü acılı, havuç taneli ve buz gibi.', 30.00, 1),
(3, 3, 'Osmanlı Şerbeti', 'Demirhindi ve baharatlarla hazırlanmış geleneksel içecek.', 45.00, 1),
(4, 3, 'Taze Portakal', 'Anlık sıkılmış, vitamin deposu.', 60.00, 1),
(5, 3, 'Ev Yapımı Limonata', 'Taze nane yaprakları ve limon dilimli.', 50.00, 1),
(6, 3, 'Soda-Limon', 'Taze sıkılmış limon suyu ile servis edilen maden suyu.', 40.00, 1),
(8, 3, 'Naneli Ayran', 'Ferahlatıcı taze nane aromalı ayran.', 35.00, 1),
(7, 3, 'Şıra', 'Kuru üzümden hazırlanan fermente içecek.', 40.00, 1),
(3, 3, 'Reyhan Şerbeti', 'Kıpkırmızı rengi ve harika kokusuyla doğal şerbet.', 45.00, 1),
(4, 3, 'Cam Şişe Kola', 'Soğuk servis edilen klasik meşrubat.', 40.00, 1);

DECLARE @sayac INT = 1;
DECLARE @rastgeleMusteriID INT;
DECLARE @rastgeleRestoranID INT;
DECLARE @rastgeleKuryeID INT;
DECLARE @rastgeleTutar DECIMAL(10,2);
DECLARE @rastgeleBagis DECIMAL(10,2);

WHILE @sayac <= 100 -- sisteme 1000 tane sipariş ekliyoruz.
BEGIN
    -- Sistemdeki mevcut ID'lerden rastgele seçim yapıyoruz (Hata almamak için en güvenli yol)
    SELECT TOP 1 @rastgeleMusteriID = MusteriID FROM Musteri ORDER BY NEWID();
    SELECT TOP 1 @rastgeleRestoranID = RestoranID FROM Restoranlar ORDER BY NEWID();
    SELECT TOP 1 @rastgeleKuryeID = KuryeID FROM Kuryeler ORDER BY NEWID();
    
    SET @rastgeleTutar = (RAND() * 250) + 100; -- 100 ile 350 TL arası sipariş
    SET @rastgeleBagis = (RAND() * 30) + 5;    -- 5 ile 35 TL arası bağış
    
    INSERT INTO Siparisler (
        MusteriID, 
        RestoranID, 
        KuryeID, 
        SiparisTarihi, 
        ToplamTutar, 
        SİparisDurumu, 
        IsAskidaSiparis, 
        BagisTutari
    )
    VALUES (
        @rastgeleMusteriID, 
        @rastgeleRestoranID, 
        @rastgeleKuryeID, 
        DATEADD(MINUTE, -@sayac * 15, GETDATE()), -- Siparişleri zamana yayıyoruz
        @rastgeleTutar, 
        'Teslim Edildi', 
        0, 
        @rastgeleBagis
    );

    SET @sayac = @sayac + 1;
END

SELECT COUNT(*) AS ToplamSiparis FROM Siparisler;
SELECT SUM(BagisTutari) AS ToplamBagisBakiye FROM Siparisler;

select *from Siparis_Detaylari

DECLARE @siparisID INT = 1;
DECLARE @rastgeleUrunID INT;
DECLARE @urunAdet INT;
DECLARE @birimFiyat DECIMAL(10,2);

-- İlk sipariştin sonuncuya kadar dönüyoruz
WHILE @siparisID <= 100
BEGIN
    -- Her siparişe rastgele 2 ürün ekleyelim (örnek olsun diye)
    DECLARE @j INT = 1;
    WHILE @j <= 2 -- Her siparişte 2 farklı ürün olsun
    BEGIN
        -- Sistemdeki mevcut ürünlerden rastgele birini seç
        SELECT TOP 1 @rastgeleUrunID = UrunID, @birimFiyat = Fiyat 
        FROM Menu_Urunler ORDER BY NEWID();
        
        SET @urunAdet = (ABS(CHECKSUM(NEWID())) % 3) + 1; -- 1 ile 3 adet arası

        INSERT INTO Siparis_Detaylari (SiparisID, UrunID, Adet, BirimFiyat)
        VALUES (@siparisID, @rastgeleUrunID, @urunAdet, @birimFiyat);

        SET @j = @j + 1;
    END
    
    SET @siparisID = @siparisID + 1;
END

select *from Siparis_Detaylari

SELECT TOP 10 * FROM Siparis_Detaylari;
select *from Musteri

INSERT INTO Musteri (Adi, Soyadi, Email, Telefon, IsActive) VALUES 
('Baran', 'Öztürk', 'baran.ozturk@mail.com', '5551112233', 1),
('Zilan', 'Aydın', 'zilan.aydin@mail.com', '5552223344', 1),
('Serhat', 'Yıldız', 'serhat.yildiz@mail.com', '5553334455', 1),
('Muhammed', 'Demir', 'muhammed.demir@mail.com', '5554445566', 1),
('Azad', 'Kaya', 'azad.kaya@mail.com', '5555556677', 1),
('Zeynep', 'Çelik', 'zeynep.celik@mail.com', '5556667788', 1),
('Fırat', 'Aslan', 'firat.aslan@mail.com', '5557778899', 1),
('Murat', 'Şahin', 'murat.sahin@mail.com', '5558889900', 1),
('Mazlum', 'Doğan', 'mazlum.dogan@mail.com', '5559990011', 1),
('Dilan', 'Korkmaz', 'dilan.korkmaz@mail.com', '5550001122', 1),
('Yusuf', 'Tekin', 'yusuf.tekin@mail.com', '5051234567', 1),
('Zeynep', 'Yılmaz', 'zeynep.yilmaz@mail.com', '5062345678', 1),
('Murat', 'Taş', 'murat.tas@mail.com', '5073456789', 1),
('Evin', 'Güneş', 'evin.gunes@mail.com', '5324567890', 1),
('Sidar', 'Bulut', 'sidar.bulut@mail.com', '5335678901', 1);

select *from Musteri

-- MUSTERİLER İÇİN ADRESLER EKLEME 
DECLARE @MusteriID INT;

-- Müşterileri tek tek gezecek döngüyü kuruyoruz
DECLARE MusteriCursor CURSOR FOR 
SELECT MusteriID FROM Musteri;

OPEN MusteriCursor;
FETCH NEXT FROM MusteriCursor INTO @MusteriID;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Her müşteriye sadece MusteriID ve AdresDetay ekliyoruz
    INSERT INTO Adresler (MusteriID, AdresDetay)
    VALUES (
        @MusteriID, 
        CASE (ABS(CHECKSUM(NEWID())) % 5) -- 5 farklı gerçekçi adres seçeneği
            WHEN 0 THEN 'Van/İpekyolu, Cumhuriyet Caddesi No:45 Kat:2'
            WHEN 1 THEN 'Van/Edremit, TOKİ Konutları 2. Etap C-12 Blok'
            WHEN 2 THEN 'Van/Tuşba, İskele Mahallesi Sahil Sokak No:10'
            WHEN 3 THEN 'Van/İpekyolu, Maraş Caddesi Aydınlar Apt. No:7'
            ELSE 'Van/Edremit, Yeni Mahalle Göl Kenarı Sitesi No:3'
        END
    );

    FETCH NEXT FROM MusteriCursor INTO @MusteriID;
END;

CLOSE MusteriCursor;
DEALLOCATE MusteriCursor;

select *from Adresler

CREATE VIEW v_RestoranCiroRaporu AS  -- her bir restoranın cirosunu falan tekte görmek  için yazılan view.
SELECT 
    R.RestoranAdi, 
    COUNT(S.SiparisID) AS ToplamSiparisSayisi, 
    SUM(S.ToplamTutar) AS ToplamCiro,
    AVG(R.RestoranPuani) AS RestoranPuani
FROM Restoranlar R
LEFT JOIN Siparisler S ON R.RestoranID = S.RestoranID
GROUP BY R.RestoranAdi;

select *from v_RestoranCiroRaporu

CREATE VIEW v_SiparisDetayliTakip AS
SELECT 
    S.SiparisID,
    M.Adi + ' ' + M.Soyadi AS MusteriAdSoyad,
    R.RestoranAdi,
    K.Ad + ' ' + K.Soyad AS KuryeAdSoyad,
    S.ToplamTutar,
    S.SiparisTarihi,
    S.SİparisDurumu
FROM Siparisler S
JOIN Musteri M ON S.MusteriID = M.MusteriID
JOIN Restoranlar R ON S.RestoranID = R.RestoranID
JOIN Kuryeler K ON S.KuryeID = K.KuryeID;

select *from v_SiparisDetayliTakip


CREATE VIEW v_AskidaYemekDurumu AS
SELECT 
    COUNT(SiparisID) AS BagisYapanSiparisSayisi,
    SUM(BagisTutari) AS ToplamBirikenBakiye
FROM Siparisler
WHERE BagisTutari > 0;

select *from v_AskidaYemekDurumu

-- Müşteri aramalarını hızlandırmak için
CREATE INDEX IX_MusteriEmail ON Musteri(Email);

-- Tarih bazlı raporları hızlandırmak için
CREATE INDEX IX_SiparisTarihi ON Siparisler(SiparisTarihi);
