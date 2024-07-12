--DDL
create database banking_system;

create type jeniskelamin as enum ('L', 'P');

create table nasabah(
	id BIGSERIAL primary key not null,
	nama varchar(250) not null, 
	email varchar(50) not null, 	
	no_telepon varchar(16) not null,
	jenis_kelamin jeniskelamin 	
);

create table alamat(
	id BIGSERIAL primary key not null,
	id_nasabah bigint unique not null,
	jalan varchar(250) not null,
	kode_pos varchar(10) not null,
	kelurahan varchar(250) not null,
	kecamatan varchar(250) not null,
	kota varchar(250) not null,
	provinsi varchar(250) not null,
	foreign key (id_nasabah) references nasabah(id) on delete cascade
);

create table detail_nasabah(
	id BIGSERIAL primary key not null,
	id_nasabah bigint unique not null,
	tanggal_lahir date not null, 
	tempat_lahir varchar(100) not null,
	foreign key (id_nasabah) references nasabah(id) on delete cascade	
);

create table akun(
	id BIGSERIAL primary key not null ,
	id_nasabah bigint not null,
	no_rekening varchar(20) unique not null ,
	jenis_rekening varchar(20) not null ,
	saldo bigint default 0 ,
	pin varchar(250) not null,
	tanggal_pembukaan date not null ,
	foreign key (id_nasabah) references nasabah(id) on delete cascade
);

create table jenis_transaksi(
	id BIGSERIAL primary key not null,
	jenis_transaksi varchar(50) not null
);

create table transaksi(
	id BIGSERIAL primary key not null ,	
	id_akun bigint not null,
	id_jenis_transaksi bigint not null,
	tanggal date not null , 
	jumlah int not null ,
	foreign key (id_jenis_transaksi) references jenis_transaksi(id),
	foreign key (id_akun) references akun(id),
	rek_tujuan varchar(250),
	tujuan_transfer varchar(250),
	berita varchar(250),
	keterangan varchar(250)
);

--DML
--Menambah data baru di tabel nasabah
insert into nasabah (nama, email, no_telepon, jenis_kelamin) 
values 
('Rafi', 'rafi@mail.com', '0812345678', 'L'),
('Rahmat', 'rahmat@mail.com', '08219837871', 'L'),
('Nisa', 'mamat@mail.com', '0812978232', 'P');

--Menambah data baru di tabel alamat (id_nasabah merupakan foreign key ke tabel nasabah)
insert into alamat (id_nasabah, jalan, kode_pos, kelurahan, kecamatan, kota, provinsi)
values 
(1,'jl.i aja dulu', '40123', 'bunijaya', 'gununghalu', 'bandung barat', 'jawa barat'),
(2,'jl.cisolok', '40124', 'cibadak', 'pelabuhan ratu', 'sukabumi', 'jawa barat'),
(3,'jl.cimol', '40123', 'ciseeng', 'cibadak', 'cianjur', 'jawa barat');

--Menambah data baru di tabel detail_nasabah (id_nasabah merupakan foreign key ke tabel nasabah)
insert into detail_nasabah (id_nasabah, tanggal_lahir, tempat_lahir)
values 
(1,'2000-01-01', 'bandung'),
(2,'2000-01-01', 'sukabumi'),
(3,'2000-01-01', 'cianjur');

--Menambah data baru di tabel akun (id_nasabah merupakan foreign key ke tabel nasabah)
insert into akun (id_nasabah, no_rekening, jenis_rekening, pin, tanggal_pembukaan)
values
(1, '1234567890', 'gold', 'kasdb12henkdkajdad', '2020-02-02'),
(2, '9876543210', 'platinum', 'vleow73juwyfoqre','2020-02-02'),
(3, '5555555555', 'gold', 'nbxzk91pqrtiouwe','2020-02-02');

--Menambah daftar jenis transaksi
insert into jenis_transaksi (jenis_transaksi)
values 
('transfer'),
('withdrawal'),
('deposit');

--Contoh transaksi deposit
insert into transaksi (tanggal, jumlah, id_akun, id_jenis_transaksi)
values
('2024-05-02', 2000000, 1, 3);

update akun set saldo = 2000000 where id = 1; 

--contoh transaksi transfer
insert into transaksi (tanggal, jumlah, id_akun, id_jenis_transaksi, rek_tujuan, tujuan_transfer, berita, keterangan)
values
('2024-06-01', 100000, 1, 1, '2312312312123', 'pemindahan dana', 'duit panas', 'jangan hambur hamburin duit mulu');

update akun set saldo = 1900000 where id = 1; 

--menampilkan data nasabah beserta akunnya masing2
select * 
from nasabah n
join akun a on n.id = a.id_nasabah;

--delete nasabah akan otomatis mendelete semua data di alamat dan detail nasabah
delete from nasabah where id=3

--cek data nasabah, apakah sudah terhapus
select * 
from nasabah n
join detail_nasabah dn on n.id = dn.id_nasabah;
