
# TextCrypt

NoteCrypt, kullanıcıların notlarını kolayca oluşturup yönetebileceği, iOS platformu için geliştirilmiş bir uygulamadır. Core Data kullanarak notların yerel olarak saklanmasını sağlar ve kullanıcı arayüzü açısından oldukça sezgisel bir deneyim sunar.

![Note List](https://i.imgur.com/K2rBqzT.png)


## Özellikler

- **Not Ekleme & Düzenleme**: Kullanıcılar, uygulamada yeni notlar oluşturabilir ve mevcut notları düzenleyebilir.
- **Tarih & Saat Bilgisi**: Her not, oluşturulduğu veya düzenlendiği tarih ve saat bilgisiyle birlikte saklanır.
- **Renkli Temalar ve Kişiselleştirme**: Uygulama, kullanıcıların tercihine bağlı olarak çeşitli renk temaları sunar. Kullanıcılar, arayüzün renklerini kişisel tercihlerine göre ayarlayabilir.
- **Kaydırarak Silme**: Kullanıcılar, notları kaydırarak kolayca silebilir. Bu özellik, modern mobil kullanıcı arayüzlerinde beklenen bir işlevselliktir.
- **Şifreleme & Güvenlik**: Notlar, güvenlik amacıyla şifrelenebilir. Bu özellik, kullanıcıların özel bilgilerini korumalarına yardımcı olur.

![Note List Delete](https://i.imgur.com/fX275Q3.png)

## Mimari ve Kod Yapısı

### Sınıflar ve İşlevleri

- **TableViewCell**: Bir notun görünümünü yönetir. Notun başlığı, içeriği, tarihi ve zamanı gibi detayları gösterir. Kullanıcıların notları silmesine olanak tanıyan bir silme butonu içerir.
- **ViewController**: Uygulamanın ana ekranını yönetir. Notların listelendiği bir tablo görünümü içerir ve `TableViewCell` ile etkileşim kurar.
- **NoteDetailViewController**: Bir notun detaylı görünümünü yönetir. Kullanıcıların not içeriğini düzenlemelerine izin verir.
- **SettingsController**: Uygulamanın ayarlar ekranını yönetir. Tema ve renk seçeneklerinin ayarlanmasını sağlar.

![Note Content](https://i.imgur.com/K2rBqzT.png)

### İletişim ve Veri Akışı

- `ViewController` ve `TableViewCell` arasında, kullanıcı arayüzündeki etkileşimler sonucunda gerçekleşen veri değişikliklerini yönetmek için bir delegasyon modeli kullanılır.
- `NoteDetailViewController`, not detaylarını düzenlemek ve güncellemek için kullanılır. Yapılan değişiklikler, Core Data üzerinden kalıcı hale getirilir.
- `SettingsController`, kullanıcıların uygulama genelindeki tema ve renk ayarlarını değiştirmelerine imkan tanır. Bu değişiklikler, kullanıcı ayarlarına kaydedilir ve uygulama genelinde uygulanır.

## Kullanıcı Arayüzü

Uygulamanın kullanıcı arayüzü, modern ve sezgisel bir tasarıma sahiptir. Ana ekran, kullanıcıların notlarını hızlıca görebileceği ve yönetebileceği bir liste sunar. Her bir not ögesi, notun başlığını, kısa içeriğini ve oluşturulma/zaman bilgisini gösterir. Kullanıcılar, notlarına dokunarak detaylı görünüme geçebilir ve düzenleyebilir. Ayarlar ekranı, uygulamanın genel görünümünü kişiselleştirmek için seçenekler sunar.

![Settings](https://i.imgur.com/4CiL7j4.png)

## Diyagramlar

### Uygulama Akış Diyagramı
Bu diyagram, uygulamanın ana ekranından ayarlara ve not detaylarına olan akışını gösterir.

### Veri Modeli Diyagramı
Core Data üzerindeki `NoteText` entity'sinin yapısını ve uygulama içindeki veri akışını gösterir.

### Sınıf İlişkileri Diyagramı
`ViewController`, `TableViewCell`, `NoteDetailViewController` ve `SettingsController` arasındaki ilişkileri ve veri akışını açıklar.

## Kurulum

Uygulamayı kurmak için Xcode ve iOS geliştirme ortamına ihtiyacınız olacak. Kodu klonladıktan sonra, Xcode üzerinden projeyi açın ve bir iOS cihazında ya da simülatörde çalıştırın.

```
git clone [repo_link]
cd NoteCrypt
open NoteCrypt.xcodeproj
```

## Katkıda Bulunma

Projeye katkıda bulunmak isteyenler, GitHub üzerinden pull request gönderebilirler. Yapılacak değişiklikler ve eklemeler için öncelikle bir issue açmanız önerilir.

## Lisans

Bu proje [MIT Lisansı](LICENSE) altında lisanslanmıştır.
