# VTYS_Yemek_Siparis_Sistemi
Müşteri, Adres, Restoran, Kategori ve Menü tablolarının oluşturulup bu tablolara verilerin eklenmesi
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
