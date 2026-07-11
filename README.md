# Bank-marketing-sql-analysis
SQL analysis of a bank telemarketing campaign with postgresql

# Banka Telepazarlama Kampanyası — SQL Müşteri Analizi

> Bir Portekiz bankasının vadeli mevduat telepazarlama kampanyasını PostgreSQL ile analiz ederek, bankanın kimi hedeflemesi gerektiğini inceledim

Hedeflerim
 -Hangi müşteriler evet demeye yatkın.
 -Farklı gruplara ne tarz kampanyalar uygun.
 -Daha önce birisi arandıysa bu onun güncel kararını etkiler mi?
 -Banka hangi gruba öncelik vermeil?

## Proje Hakkında

Verim UCI bank marketing dataset, gerçek bir iş problemini temsil ettiği için başlamaya karar verdim. Hedefim hangi kategorideki müşteriler evet demeye daha yatkın. Hangi müşteriler için ne gibi bir kampanya yapılabilir. Birkaç kez aranan müşterinin tekrar arandığında evet deme oranı nedir. Bankanın hangi müşterilere öncelik vermesi gerekir gibi sorulara cevap bulmaya çalıştım.

PostgreSQL, SQL, DBeaver kullandım.

Veri setim: https://www.kaggle.com/datasets/prakharrathi25/banking-dataset-marketing-targets

Yaklaşık 45.000 kişilik bir veri seti. Y sutunu evet, hayır cevabını içeriyor ve bu veri setinde en önemli sutunlardan bir tanesi. Hem kategorik (job, marital) hem sayısal (age, balance) değişkenler mevcut. Veri dengesiz çünkü, yaklaşık %11.7 evet, %88 hayır var.

## Bulgular
### 1. Genel Dönüşüm (Baseline)
Evet diyenlerin genel ortalaması %11.7, sorgularımı yaparken bu yüzdeye göre karşılaştırmalar yaptım.

### 2. Mesleğe Göre Dönüşüm
Öğrenciler %28.6 ile emekliler %22.7 ile genel ortalamanın çok üstünde evet oranına sahip. Emekliler ve öğrenciler diğer gruplara kıyasla vadeli
mevduata çok sıcak bakıyorlar.
| Sıra | Meslek | evet_oranı |
|------|--------------|-----------|
| 1 | student | 28.68 |
| 2 | retired | 22.79 |
| 3 | unemployed | 15.50 |
| 4 | management | 13.76 |
| 5 | admin. | 12.20 |
| 6 | self-employed | 11.84 |
| 7 | unknown | 11.81 |
| 8 | technician | 11.06 |
| 9 | services | 8.88 |
| 10 | housemaid | 8.79 |
| 11 | entrepreneur | 8.27 |
| 12 | blue-collar | 7.27 |



###3. Bekarlık
Bekarların ortalaması yaklaşık %15, öğrencileri çıkarınca bu durum yaklaşık %14’e düşüyor. Bu değişkenler birbirinden bağımsız.

### 4. Bakiye Merdiveni
Düşük alım gücü %6.9 evet yüzdesine sahip, orta alım gücü %10.88 evet yüzdesine sahip, yüksek alım gücü %15.39 evet yüzdesine sahip. Monoton artan bir şekilde ilerliyor. Alım gücü arttıkça insanların vadelı mevduata evet deme yüzdesı artıyor.

### 5. Öğrenci İstisnası
Öğrenciler en yüksek evet yüzdesine sahipti %28.68, fakat alım gücü olarak 7nci sıradalar. Bu istisnanın sebebi öğrencilerin farklı motivasyonlara sahip olmasından kaynaklanıyor olabilir. Örnek olarak, geleceğe yatırım mantığı, alışkanlığa dönüştürme, veya zamanın bol olması gibi.

### 6. Yaşa Göre Dönüşüm 
genç kesimin %17.6 evet yüzdesi var, orta kesimin %9.9 evet yüzdesi var, yaşlı kesimin %14.2 evet yüzdesi var. En çok evet diyenlerde emekliler ve öğrenciler vardı. Burada da onların etkisini görüyoruz.Genç kesim en çok evet yüzdesine sahip, sonra %14.2 ile yaşlı kesim onu takip ediyor.

### 7. Önceki Kampanya Sonucu (Poutcome)
Öncekı kampanyaya evet diyenlerin %64.7i güncel kampanyaya evet demiş. Fakat yaklaşık 1.500 kişi olduğundan dolayı örneklem büyüklüğü küçük. Genel ortalamanın yaklaşık 5.5 katı ve güçlü bir tahmin edici fakat kapsamı küçük. Önceki kampanyaya hayır diyenlerin %12.7si güncel kampanyaya evet cevabı vermiş. Yani genel ortalamaya yakın bir değer, önceki kampanyaya hayır demek sonucu etkilemiyor.

 

### 8. Arama Sayısı (Campaign)
İlk kez arananlar %14.6 sonra monoton bir şekilde azalıyor. Yani tekrar tekrar aramanın verimi düşük.

### 9. Geçmiş Temas (previous)
Daha önce arananlar müşteriler yüzde %23.07 evet yüzdesine sahip, daha önce hiç aranmamış müşteriler %9.16 evet yüzdesine sahip. Poutcome sutunundakı unknownun da yüzdesi aklaşık %9'du, yani birbirlerini doğruluyorlar.


## İş Önerileri 

1.	Daha önce kampanyaya evet diyenlerin güncel bir kampanyaya evet deme yüzdesi %64.7, ama örneklem büyüklüğü küçük, tek başına yeterli değil, onlara öncelik verilmeli.

2.	Öğrenciler kampanyaya karşı ilgili fakat öğrencilerin bakiyeleri düşük. O yüzden öğrencilere özel teklifler hazırlanması iyi olabilir. Bir kez bankaya alışan ve bankanın sistemine giren öğrenciler düzenli bir getiri sağladıklarında bu alışkanlıklarını devam ettirme eğilimi gösterebilirler.

3.	Arama sayısı arttıkça evet yüzdesi azalıyor. Bu yüzden tekrar tekrar aramak verimsiz, gözden çıkarılabilir.

4.	Düşük alım gücüne sahip müşteriler %6.9 evet yüzdesine sahip, genel ortalamanın çok altında bu yüzden kampanya dışı bırakılabilirler.

Not: Bu öneriler sadece gözlemsel bulgulara dayanmaktadır. Daha net ve kesin sonuç için detaylı araştırma yapılmalıdır.

