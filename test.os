#Использовать notify
#Использовать stream

Процедура ОбработчикФильтрации(Результат, ДополнительныеПараметры) Экспорт
	Элемент = ДополнительныеПараметры.Элемент;
	Результат = Элемент > 3;
КонецПроцедуры

Процедура ОбработчикОбработки(Результат, ДополнительныеПараметры) Экспорт
	Элемент = ДополнительныеПараметры.Элемент;
	Результат = Элемент + 1;
	Сообщить("Я - операция map, и это мое послание миру: элемент " + Элемент + " превратился в " + Результат);
КонецПроцедуры

Процедура ОбработчикСокращения(Результат, ДополнительныеПараметры) Экспорт
	Элемент = ДополнительныеПараметры.Элемент;
	Результат = Результат + Элемент;
КонецПроцедуры

ФункцияФильтрации = ОписанияОповещений.Создать("ОбработчикФильтрации", ЭтотОбъект);
ФункцияОбработки = ОписанияОповещений.Создать("ОбработчикОбработки", ЭтотОбъект);
ФункцияСокращения = ОписанияОповещений.Создать("ОбработчикСокращения", ЭтотОбъект);

Массив = Новый Массив;
Массив.Добавить(3);
Массив.Добавить(4);
Массив.Добавить(7);
Массив.Добавить(5);
Массив.Добавить(1);
Массив.Добавить(0);

Стрим = Новый Стрим;
Стрим.УстановитьКоллекцию(Массив);

Результат = Стрим
	.Пропустить(2)
	.Фильтровать(ФункцияФильтрации)
	.Первые(2)
	.Обработать(ФункцияОбработки)
	.ДляКаждого(Потоки.СтандартныйОбработчик_Сообщить());

Стрим = Потоки.ИзКоллекции(Массив);
Результат = Стрим
	.Сортировать()
	.ДляКаждого(Потоки.СтандартныйОбработчик_Сообщить());

Массив = Новый Массив;
Массив.Добавить(4);
Массив.Добавить(2);
Массив.Добавить(2);
Массив.Добавить(3);
Массив.Добавить(3);
Массив.Добавить(3);

Стрим = Потоки.ИзКоллекции(Массив);
Результат = Стрим
	.Различные()
	.ДляКаждого(Потоки.СтандартныйОбработчик_Сообщить());

Стрим = Потоки.ИзКоллекции(Массив);
Результат = Стрим
	.Обработать(ФункцияОбработки)
	.Сократить(ФункцияСокращения, 0);

Сообщить(Результат);

// Результат должен различаться
Потоки.ИзКоллекции(Массив).Сортировать().Первые(1).ДляКаждого(Потоки.СтандартныйОбработчик_Сообщить());
Сообщить(Массив[0]);
