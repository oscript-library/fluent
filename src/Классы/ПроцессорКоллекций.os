#Использовать notify
#Использовать logos
#Использовать strings

#Использовать "../internal"

Перем Лог;

Перем Конвейер;
Перем ПроцессорКоллекцийСлужебный;
Перем ВременныеОписанияОповещений;
Перем ТекстШаблонаИзолированногоКласса;

// Общее API

// Устанавливает коллекцию для обработки Процессора коллекций.
//
// Параметры:
//   НоваяКоллекция - Массив, ТаблицаЗначений, ДеревоЗначений... - Коллекция, устанавливаемая в процессор.
//
Процедура УстановитьКоллекцию(НоваяКоллекция) Экспорт
	ПроцессорКоллекцийСлужебный.УстановитьКоллекцию(НоваяКоллекция);
	Лог.Отладка("Установлена коллекция размером %1", ПроцессорКоллекцийСлужебный.ПолучитьКоллекцию().Количество());
КонецПроцедуры

// Конвейерные методы

// Получить первые N элементов.
// Конвейерный метод.
//
// Параметры:
//   Количество - Число - Число отбираемых элементов.
//
//  Возвращаемое значение:
//   ПроцессорКоллекций - Инстанс класса "ПроцессорКоллекций".
//
Функция Первые(Количество) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Количество", Количество);
	
	ПоложитьЯчейкуВКонвейер("Первые", , ДополнительныеПараметры);
	Возврат ЭтотОбъект;

КонецФункции

// Пропустить первые N элементов.
// Конвейерный метод.
//
// Параметры:
//   Количество - Число - Число пропускаемых элементов.
//
// Возвращаемое значение:
//   ПроцессорКоллекций - Инстанс класса "ПроцессорКоллекций".
//
Функция Пропустить(Количество) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Количество", Количество);
	
	ПоложитьЯчейкуВКонвейер("Пропустить", , ДополнительныеПараметры);
	Возврат ЭтотОбъект;

КонецФункции

// Выбрать различные элементы.
// Конвейерный метод.
//
// Параметры:
//   ФункцияСравнения - Строка, ОписаниеОповещения - Функция сравнения.
//		В случае передачи Строки формируется служебное описание оповещения, в контексте которого заданы переменные
//		"Результат", "ДополнительныеПараметры", "Элемент1", "Элемент2".
//		В случае передачи ОписанияОповещения обработчик данного описания должен содержать два параметра 
//		(имена произвольные):
//			"Результат" - Булево - Переменная, в которой возвращается значение работы функции.
//			"ДополнительныеПараметры" - Структура - Структура параметров, передаваемая функции.
//		Если параметр не передан, выполняется стандартная функция сравнения:
//		см. ПроцессорыКоллекций.СтандартнаяФункцияСравнения()
//		
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров, передаваемая функции сравнения.
//		Служит для передачи дополнительных данных из прикладного кода в функцию сравнения.
//		По умолчанию содержит два значения - Элемент1 и Элемент2.
//
//  Возвращаемое значение:
//   ПроцессорКоллекций - Инстанс класса "ПроцессорКоллекций".
//
//  Примеры:
//		1:
//		ПроцессорКоллекций.Различные("Результат = Элемент1 > Элемент2");
//
//		2:
//		Процедура МояФункцияСравнения(Результат, ДополнительныеПараметры) Экспорт
//			Результат = ДополнительныеПараметры.Элемент1 > ДополнительныеПараметры.Элемент2;
//		КонецПроцедуры
//		
//		ФункцияСравнения = ОписанияОповещений.Создать("МояФункцияСравнения", ЭтотОбъект);
//		ПроцессорКоллекций.Различные(ФункцияСравнения);
//
Функция Различные(Знач ФункцияСравнения = Неопределено, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Если ФункцияСравнения = Неопределено Тогда
		ФункцияСравнения = ПроцессорыКоллекций.СтандартнаяФункцияСравнения();
	Иначе
		Если ТипЗнч(ФункцияСравнения) = Тип("Строка") Тогда
			ФункцияСравнения = СформироватьВременноеОписаниеОповещения(ФункцияСравнения, ДополнительныеПараметры);
		КонецЕсли;	
	КонецЕсли;

	ПоложитьЯчейкуВКонвейер("Различные", ФункцияСравнения);
	Возврат ЭтотОбъект;
	
КонецФункции

// Обработать каждый элемент коллекции.
// Конвейерный метод.
//
// Параметры:
//   ФункцияОбработки - Строка, ОписаниеОповещения - функция обработки.
//		В случае передачи Строки формируется служебное описание оповещения, в контексте которого заданы переменные
//		"Результат", "ДополнительныеПараметры", "Элемент".
//		В случае передачи ОписанияОповещения обработчик данного описания должен содержать два параметра 
//		(имена произвольные):
//			"Результат" - Произвольный - Переменная, в которой возвращается значение работы обработчика.
//			"ДополнительныеПараметры" - Структура - Структура параметров, передаваемая обработчику.
//		
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров, передаваемая функции обработки.
//		Служит для передачи дополнительных данных из прикладного кода в функцию обработки.
//		По умолчанию содержит одно значение - Элемент.
//
//  Возвращаемое значение:
//   ПроцессорКоллекций - Инстанс класса "ПроцессорКоллекций".
//
//  Примеры:
//		1:
//		ПроцессорКоллекций.Обработать("Результат = Элемент + 1;");
//
//		2:
//		Процедура МояФункцияОбработки(Результат, ДополнительныеПараметры) Экспорт
//			Результат = ДополнительныеПараметры.Элемент + 1;
//		КонецПроцедуры
//		
//		ФункцияОбработки = ОписанияОповещений.Создать("МояФункцияОбработки", ЭтотОбъект);
//		ПроцессорКоллекций.Обработать(ФункцияОбработки);
//
Функция Обработать(Знач ФункцияОбработки, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(ФункцияОбработки) = Тип("Строка") Тогда
		ФункцияОбработки = СформироватьВременноеОписаниеОповещения(ФункцияОбработки, ДополнительныеПараметры);
	КонецЕсли;
	
	ПоложитьЯчейкуВКонвейер("Обработать", ФункцияОбработки);
	Возврат ЭтотОбъект;

КонецФункции

// Фильтровать коллекцию по условию.
// Конвейерный метод.
//
// Параметры:
//   ФункцияФильтрации - Строка, ОписаниеОповещения - Функция фильтрации.
//		В случае передачи Строки формируется служебное описание оповещения, в контексте которого заданы переменные
//		"Результат", "ДополнительныеПараметры", "Элемент".
//		В случае передачи ОписанияОповещения обработчик данного описания должен содержать два параметра 
//		(имена произвольные):
//			"Результат" - Булево - Переменная, в которой возвращается значение работы функции.
//			"ДополнительныеПараметры" - Структура - Структура параметров, передаваемая функции.
//		
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров, передаваемая функции фильтрации.
//		Служит для передачи дополнительных данных из прикладного кода в функцию фильтрации.
//		По умолчанию содержит одно значение - Элемент.
//
//  Возвращаемое значение:
//   ПроцессорКоллекций - Инстанс класса "ПроцессорКоллекций".
//
//  Примеры:
//		1:
//		ПроцессорКоллекций.Фильтровать("Результат = СтрДлина(Элемент) > 1");
//
//		2:
//		Процедура МояПроцедураФильтрации(Результат, ДополнительныеПараметры) Экспорт
//			Результат = СтрДлина(ДополнительныеПараметры.Элемент) > 1;
//		КонецПроцедуры
//		
//		ФункцияФильтрации = ОписанияОповещений.Создать("МояПроцедураФильтрации", ЭтотОбъект);
//		ПроцессорКоллекций.Фильтровать(ФункцияФильтрации);
//
Функция Фильтровать(Знач ФункцияФильтрации, Знач ДополнительныеПараметры = Неопределено) Экспорт
		
	Если ТипЗнч(ФункцияФильтрации) = Тип("Строка") Тогда
		ФункцияФильтрации = СформироватьВременноеОписаниеОповещения(ФункцияФильтрации, ДополнительныеПараметры);
	КонецЕсли;

	ПоложитьЯчейкуВКонвейер("Фильтровать", ФункцияФильтрации);
	Возврат ЭтотОбъект;

КонецФункции

// Сортировать элементы коллекции.
// Конвейерный метод.
//
// Параметры:
//   ФункцияСравнения - Строка, ОписаниеОповещения - Функция сравнения.
//		В случае передачи Строки формируется служебное описание оповещения, в контексте которого заданы переменные
//		"Результат", "ДополнительныеПараметры", "Элемент1", "Элемент2".
//		В случае передачи ОписанияОповещения обработчик данного описания должен содержать два параметра 
//		(имена произвольные):
//			"Результат" - Булево - Переменная, в которой возвращается значение работы функции.
//			"ДополнительныеПараметры" - Структура - Структура параметров, передаваемая функции.
//		Если параметр не передан, выполняется стандартная функция сравнения:
//		см. ПроцессорыКоллекций.СтандартнаяФункцияСравнения()
//		
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров, передаваемая функции сравнения.
//		Служит для передачи дополнительных данных из прикладного кода в функцию сравнения.
//		По умолчанию содержит два значения - Элемент1 и Элемент2.
//
//  Возвращаемое значение:
//   ПроцессорКоллекций - Инстанс класса "ПроцессорКоллекций".
//
//  Примеры:
//		1:
//		ПроцессорКоллекций.Сортировать("Результат = Элемент1 > Элемент2");
//
//		2:
//		Процедура МояФункцияСравнения(Результат, ДополнительныеПараметры) Экспорт
//			Результат = ДополнительныеПараметры.Элемент1 > ДополнительныеПараметры.Элемент2;
//		КонецПроцедуры
//		
//		ФункцияСравнения = ОписанияОповещений.Создать("МояФункцияСравнения", ЭтотОбъект);
//		ПроцессорКоллекций.Сортировать(ФункцияСравнения);
//
Функция Сортировать(Знач ФункцияСравнения = Неопределено, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ФункцияСравнения = Неопределено Тогда
		ФункцияСравнения = ПроцессорыКоллекций.СтандартнаяФункцияСравнения();
	Иначе
		Если ТипЗнч(ФункцияСравнения) = Тип("Строка") Тогда
			ФункцияСравнения = СформироватьВременноеОписаниеОповещения(ФункцияСравнения, ДополнительныеПараметры);
		КонецЕсли;
	КонецЕсли;

	ПоложитьЯчейкуВКонвейер("Сортировать", ФункцияСравнения);
	Возврат ЭтотОбъект;
	
КонецФункции

// Терминальные методы

// Получить первый элемент.
// Терминальный метод.
//
//  Возвращаемое значение:
//   Произвольный - Первый элемент из коллекции. Если коллекция пуста, возвращает Неопределено.
//
Функция ПолучитьПервый() Экспорт
	Лог.Отладка("ПолучитьПервый");
	
	ПройтиКонвейер();

	Результат = Неопределено;
	Коллекция = ПроцессорКоллекцийСлужебный.ПолучитьКоллекцию();
	Для Каждого Элемент Из Коллекция Цикл
		Результат = Элемент;
		Прервать;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

// Получить коллекцию в виде массива.
// Терминальный метод.
//
//  Возвращаемое значение:
//   Массив - Массив элементов коллекции.
//
Функция ВМассив() Экспорт
	
	Лог.Отладка("ВМассив");

	ПройтиКонвейер();

	Результат = Новый Массив;
	Коллекция = ПроцессорКоллекцийСлужебный.ПолучитьКоллекцию();
	Для Каждого Элемент Из Коллекция Цикл
		Результат.Добавить(Элемент);
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Получить коллекцию в виде строки.
// Терминальный метод.
//
// Параметры:
//	РазделительСтрок - Строка - Используемый разделитель между элементами при конкатенации строк.
// 
//  Возвращаемое значение:
//   Строка - Элементы коллекции, соединенные в строку методом конкатенации.
//
Функция ВСтроку(РазделительСтрок = "") Экспорт
	Лог.Отладка("ВСтроку");
	
	ПройтиКонвейер();
	
	Результат = "";
	Коллекция = ПроцессорКоллекцийСлужебный.ПолучитьКоллекцию();
	Для Каждого Элемент Из Коллекция Цикл
		Результат = Результат + Элемент + РазделительСтрок;
	КонецЦикла;
	
	Если НЕ РазделительСтрок = "" И СтрДлина(Результат) > 0 Тогда
		СтроковыеФункции.УдалитьПоследнийСимволВСтроке(Результат, СтрДлина(РазделительСтрок));
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Получить количество элементов коллекции.
// Терминальный метод.
//
//  Возвращаемое значение:
//   Число - Количество элементов коллекции.
//
Функция Количество() Экспорт
	
	Лог.Отладка("Количество");
	
	ПройтиКонвейер();
	
	Коллекция = ПроцессорКоллекцийСлужебный.ПолучитьКоллекцию();
	Результат = Коллекция.Количество();
	
	Возврат Результат;

КонецФункции

// Обработать каждый элемент коллекции и завершить работу процессора.
// Терминальный метод.
//
// Параметры:
//   ФункцияОбработки - Строка, ОписаниеОповещения - функция обработки.
//		В случае передачи Строки формируется служебное описание оповещения, в контексте которого заданы переменные
//		"Результат", "ДополнительныеПараметры", "Элемент".
//		В случае передачи ОписанияОповещения обработчик данного описания должен содержать два параметра 
//		(имена произвольные):
//			"Результат" - Произвольный - Игнорируется.
//			"ДополнительныеПараметры" - Структура - Структура параметров, передаваемая обработчику.
//
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров, передаваемая функции обработки.
//		Служит для передачи дополнительных данных из прикладного кода в функцию обработки.
//		По умолчанию содержит одно значение - Элемент.
//
//  Примеры:
//		1:
//		ПроцессорКоллекций.ДляКаждого("Сообщить(Элемент);");
//
//		2:
//		ПроцессорКоллекций.ДляКаждого(ПроцессорыКоллекций.СтандартнаяФункцияОбработки_Сообщить());
//
//		3:
//		Процедура МояФункцияОбработки(Результат, ДополнительныеПараметры) Экспорт
//			Сообщить(ДополнительныеПараметры.Элемент);
//		КонецПроцедуры
//		
//		ФункцияОбработки = ОписанияОповещений.Создать("МояФункцияОбработки", ЭтотОбъект);
//		ПроцессорКоллекций.ДляКаждого(ФункцияОбработки);
//
Процедура ДляКаждого(Знач ФункцияОбработки, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Лог.Отладка("ДляКаждого");

	Если ТипЗнч(ФункцияОбработки) = Тип("Строка") Тогда
		ФункцияОбработки = СформироватьВременноеОписаниеОповещения(ФункцияОбработки, ДополнительныеПараметры);
	КонецЕсли;

	ПройтиКонвейер();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Обработчик", ФункцияОбработки);

	ПроцессорКоллекцийСлужебный.ВыполнитьОбработать(Неопределено, ДополнительныеПараметры);
	
	ОчиститьВременныеОписанияОповещений();

КонецПроцедуры

// Получить минимальный элемент.
// Терминальный метод.
//
// Параметры:
//   ФункцияСравнения - Строка, ОписаниеОповещения - Функция сравнения.
//		В случае передачи Строки формируется служебное описание оповещения, в контексте которого заданы переменные
//		"Результат", "ДополнительныеПараметры", "Элемент1", "Элемент2".
//		В случае передачи ОписанияОповещения обработчик данного описания должен содержать два параметра 
//		(имена произвольные):
//			"Результат" - Булево - Переменная, в которой возвращается значение работы функции.
//			"ДополнительныеПараметры" - Структура - Структура параметров, передаваемая функции.
//		Если параметр не передан, выполняется стандартная функция сравнения:
//		см. ПроцессорыКоллекций.СтандартнаяФункцияСравнения()
//		
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров, передаваемая функции сравнения.
//		Служит для передачи дополнительных данных из прикладного кода в функцию сравнения.
//		По умолчанию содержит два значения - Элемент1 и Элемент2.
//
//  Возвращаемое значение:
//   Произвольный - минимальный элемент коллекции.
//
//  Примеры:
//		1:
//		ПроцессорКоллекций.Минимум();
//
//		2:
//		ПроцессорКоллекций.Минимум("Результат = Элемент1 > Элемент2");
//
//		3:
//		Процедура МояФункцияСравнения(Результат, ДополнительныеПараметры) Экспорт
//			Результат = ДополнительныеПараметры.Элемент1 > ДополнительныеПараметры.Элемент2;
//		КонецПроцедуры
//		
//		ФункцияСравнения = ОписанияОповещений.Создать("МояФункцияСравнения", ЭтотОбъект);
//		ПроцессорКоллекций.Минимум(ФункцияСравнения);
//
Функция Минимум(Знач ФункцияСравнения = Неопределено, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Лог.Отладка("Минимум");
	
	Если ФункцияСравнения = Неопределено Тогда
		ФункцияСравнения = ПроцессорыКоллекций.СтандартнаяФункцияСравнения();
	Иначе
		Если ТипЗнч(ФункцияСравнения) = Тип("Строка") Тогда
			ФункцияСравнения = СформироватьВременноеОписаниеОповещения(ФункцияСравнения, ДополнительныеПараметры);
		КонецЕсли;
	КонецЕсли;

	ПройтиКонвейер();
	
	Результат = Новый Массив;
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Обработчик", ФункцияСравнения);
	
	ПроцессорКоллекцийСлужебный.ВыполнитьСортировать(Результат, ДополнительныеПараметры);
	
	ОчиститьВременныеОписанияОповещений();

	Если Результат.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат Результат[0];
	КонецЕсли;

КонецФункции

// Получить максимальный элемент.
// Терминальный метод.
//
// Параметры:
//   ФункцияСравнения - Строка, ОписаниеОповещения - Функция сравнения.
//		В случае передачи Строки формируется служебное описание оповещения, в контексте которого заданы переменные
//		"Результат", "ДополнительныеПараметры", "Элемент1", "Элемент2".
//		В случае передачи ОписанияОповещения обработчик данного описания должен содержать два параметра 
//		(имена произвольные):
//			"Результат" - Булево - Переменная, в которой возвращается значение работы функции.
//			"ДополнительныеПараметры" - Структура - Структура параметров, передаваемая функции.
//		Если параметр не передан, выполняется стандартная функция сравнения:
//		см. ПроцессорыКоллекций.СтандартнаяФункцияСравнения()
//		
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров, передаваемая функции сравнения.
//		Служит для передачи дополнительных данных из прикладного кода в функцию сравнения.
//		По умолчанию содержит два значения - Элемент1 и Элемент2.
//
//  Возвращаемое значение:
//   Произвольный - максимальный элемент коллекции.
//
//  Примеры:
//		1:
//		ПроцессорКоллекций.Максимум();
//
//		2:
//		ПроцессорКоллекций.Максимум("Результат = Элемент1 > Элемент2");
//
//		3:
//		Процедура МояФункцияСравнения(Результат, ДополнительныеПараметры) Экспорт
//			Результат = ДополнительныеПараметры.Элемент1 > ДополнительныеПараметры.Элемент2;
//		КонецПроцедуры
//		
//		ФункцияСравнения = ОписанияОповещений.Создать("МояФункцияСравнения", ЭтотОбъект);
//		ПроцессорКоллекций.Максимум(ФункцияСравнения);
//
Функция Максимум(Знач ФункцияСравнения = Неопределено, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Лог.Отладка("Максимум");
	
	Если ФункцияСравнения = Неопределено Тогда
		ФункцияСравнения = ПроцессорыКоллекций.СтандартнаяФункцияСравнения();
	Иначе
		Если ТипЗнч(ФункцияСравнения) = Тип("Строка") Тогда
			ФункцияСравнения = СформироватьВременноеОписаниеОповещения(ФункцияСравнения, ДополнительныеПараметры);
		КонецЕсли;
	КонецЕсли;
	
	ПройтиКонвейер();
	
	Результат = Новый Массив;
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Обработчик", ФункцияСравнения);
	
	ПроцессорКоллекцийСлужебный.ВыполнитьСортировать(Результат, ДополнительныеПараметры);
	
	ОчиститьВременныеОписанияОповещений();
		
	Если Результат.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат Результат[Результат.Количество() - 1];
	КонецЕсли;
	
КонецФункции

// Выполнить агрегатную функцию над элементами коллекции.
// Терминальный метод.
//
// Параметры:
//   ФункцияСокращения - Строка, ОписаниеОповещения - Функция сокращения.
//		В случае передачи Строки формируется служебное описание оповещения, в контексте которого заданы переменные
//		"Результат", "ДополнительныеПараметры", "Элемент".
//		В случае передачи ОписанияОповещения обработчик данного описания должен содержать два параметра 
//		(имена произвольные):
//			"Результат" - Произвольный - Переменная, в которой возвращается значение работы функции.
//			"ДополнительныеПараметры" - Структура - Структура параметров, передаваемая функции.
//
//   НачальноеЗначение - Произвольный - начальное значение, передаваемое в функцию сокращения в параметр "Результат"
//
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров, передаваемая функции сокращения.
//		Служит для передачи дополнительных данных из прикладного кода в функцию сокращения.
//		По умолчанию содержит одно значение - Элемент.
//
//  Возвращаемое значение:
//   Произвольный - результат работы агрегатной функции.
//
//  Примеры:
//		2:
//		ПроцессорКоллекций.Сократить("Результат = Результат + Элемент");
//
//		2:
//		Процедура МояФункцияСокращения(Результат, ДополнительныеПараметры) Экспорт
//				Элемент = ДополнительныеПараметры.Элемент;
//				Результат = Результат + Элемент;
//		КонецПроцедуры
//		
//		ФункцияСокращения = ОписанияОповещений.Создать("МояФункцияСокращения", ЭтотОбъект);
//		ПроцессорКоллекций.Сократить(ФункцияСокращения);
//
Функция Сократить(Знач ФункцияСокращения,
                  Знач НачальноеЗначение = Неопределено,
                  Знач ДополнительныеПараметры = Неопределено) Экспорт

	Лог.Отладка("Сократить");
	
	Если ТипЗнч(ФункцияСокращения) = Тип("Строка") Тогда
		ФункцияСокращения = СформироватьВременноеОписаниеОповещения(ФункцияСокращения, ДополнительныеПараметры);
	КонецЕсли;

	ПройтиКонвейер();

	Результат = НачальноеЗначение;
	Коллекция = ПроцессорКоллекцийСлужебный.ПолучитьКоллекцию();
	Для Каждого Элемент Из Коллекция Цикл
		Если ФункцияСокращения.ДополнительныеПараметры = Неопределено Тогда
			ФункцияСокращения.ДополнительныеПараметры = Новый Структура;
		КонецЕсли;
		ФункцияСокращения.ДополнительныеПараметры.Вставить("Элемент", Элемент);
		ОписанияОповещений.ВыполнитьОбработкуОповещения(ФункцияСокращения, Результат);
	КонецЦикла;

	ОчиститьВременныеОписанияОповещений();
	
	Возврат Результат;

КонецФункции

// Получить коллекцию в виде объекта заданного типа.
// Терминальный метод.
//
// Параметры:
//   ТипРезультата - Тип - Тип, в котором необходимо вернуть коллекцию.
//
//  Возвращаемое значение:
//   Произвольный - Коллекция в виде объекта нужного типа.
//
Функция Получить(ТипРезультата) Экспорт
	
	Лог.Отладка("Получить %1", ТипРезультата);
	
	ПройтиКонвейер();
	
	Коллекция = ПроцессорКоллекцийСлужебный.ПолучитьКоллекцию();
	КэшКолонок = ПроцессорКоллекцийСлужебный.ПолучитьКэшКолонок();
	
	Результат = Новый(ТипРезультата);
	
	РезультатСодержитКолонки = Истина;
	Попытка
		Колонки = Результат.Колонки;
	Исключение
		РезультатСодержитКолонки = Ложь;
	Конецпопытки;

	Если РезультатСодержитКолонки Тогда
		Для Каждого Колонка Из КэшКолонок Цикл
			Результат.Колонки.Добавить(
				Колонка.Имя,
				Колонка.ТипЗначения,
				Колонка.Заголовок,
				Колонка.Ширина
			);
		КонецЦикла;
	
		Если Результат.Колонки.Количество() = 0 Тогда
			Результат.Колонки.Добавить("Значение");
		КонецЕсли;
	КонецЕсли;

	ЭлементСодержитКолонки = КэшКолонок.Количество() > 0;
	Лог.Отладка("Результат содержит колонки %1", РезультатСодержитКолонки);
	Лог.Отладка("Элемент содержит колонки %1", ЭлементСодержитКолонки);
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		Если РезультатСодержитКолонки И ЭлементСодержитКолонки Тогда
			ЗаполнитьЗначенияСвойств(Результат.Добавить(), ЭлементКоллекции);
		ИначеЕсли РезультатСодержитКолонки Тогда
			НоваяСтрока = Результат.Добавить();
			НоваяСтрока.Значение = ЭлементКоллекции;
		Иначе
			Результат.Добавить(ЭлементКоллекции);
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Проверить, что хотя бы один элемент коллекции удовлетворяет условию в функции сравнения.
// Терминальный метод.
//
// Параметры:
//   ФункцияСравнения - Строка, ОписаниеОповещения - Функция сравнения.
//		В случае передачи Строки формируется служебное описание оповещения, в контексте которого заданы переменные
//		"Результат", "ДополнительныеПараметры", "Элемент".
//		В случае передачи ОписанияОповещения обработчик данного описания должен содержать два параметра 
//		(имена произвольные):
//			"Результат" - Булево - Переменная, в которой возвращается значение работы функции.
//			"ДополнительныеПараметры" - Структура - Структура параметров, передаваемая функции.
//
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров, передаваемая функции сравнения.
//		Служит для передачи дополнительных данных из прикладного кода в функцию сравнения.
//		По умолчанию содержит одно значение - Элемент.
//
//  Возвращаемое значение:
//   Булево - Истина, если минимум один из элементов коллекции удовлетворяет условию Функции сравнения.
//		В обратном случае возвращает Ложь.
//		Если коллекция пустая, возвращает Ложь.
//
Функция ЛюбойСоответствует(Знач ФункцияСравнения, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Лог.Отладка("ЛюбойСоответствует");
	
	Если ТипЗнч(ФункцияСравнения) = Тип("Строка") Тогда
		ФункцияСравнения = СформироватьВременноеОписаниеОповещения(ФункцияСравнения, ДополнительныеПараметры);
	КонецЕсли;

	ПройтиКонвейер();
	
	Коллекция = ПроцессорКоллекцийСлужебный.ПолучитьКоллекцию();
	Результат = Ложь;

	Если ФункцияСравнения.ДополнительныеПараметры = Неопределено Тогда
		ФункцияСравнения.ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	ФункцияСравнения.ДополнительныеПараметры.Вставить("Элемент");

	Для Каждого Элемент Из Коллекция Цикл
		ФункцияСравнения.ДополнительныеПараметры.Элемент = Элемент;
		РезультатФильтрации = Ложь;
		ОписанияОповещений.ВыполнитьОбработкуОповещения(ФункцияСравнения, РезультатФильтрации);
		
		Если РезультатФильтрации Тогда
			Результат = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	ОчиститьВременныеОписанияОповещений();
	
	Возврат Результат;

КонецФункции

// Проверить, что все элементы коллекции удовлетворяют условию в функции сравнения.
// Терминальный метод.
//
// Параметры:
//   ФункцияСравнения - Строка, ОписаниеОповещения - Функция сравнения.
//		В случае передачи Строки формируется служебное описание оповещения, в контексте которого заданы переменные
//		"Результат", "ДополнительныеПараметры", "Элемент".
//		В случае передачи ОписанияОповещения обработчик данного описания должен содержать два параметра 
//		(имена произвольные):
//			"Результат" - Булево - Переменная, в которой возвращается значение работы функции.
//			"ДополнительныеПараметры" - Структура - Структура параметров, передаваемая функции.
//
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров, передаваемая функции сравнения.
//		Служит для передачи дополнительных данных из прикладного кода в функцию сравнения.
//		По умолчанию содержит одно значение - Элемент.
//
//  Возвращаемое значение:
//   Булево - Истина, если все элементы коллекции удовлетворяют условию Функции сравнения.
//		В обратном случае возвращает Ложь.
//		Если коллекция пустая, возвращает Истина.
//
Функция ВсеСоответствуют(Знач ОписаниеОповещения, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Лог.Отладка("ВсеСоответствуют");
	
	Если ТипЗнч(ОписаниеОповещения) = Тип("Строка") Тогда
		ОписаниеОповещения = СформироватьВременноеОписаниеОповещения(ОписаниеОповещения, ДополнительныеПараметры);
	КонецЕсли;

	ПройтиКонвейер();
	
	Коллекция = ПроцессорКоллекцийСлужебный.ПолучитьКоллекцию();
	Результат = Истина;
	
	Если ОписаниеОповещения.ДополнительныеПараметры = Неопределено Тогда
		ОписаниеОповещения.ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	ОписаниеОповещения.ДополнительныеПараметры.Вставить("Элемент");
	
	Для Каждого Элемент Из Коллекция Цикл
		ОписаниеОповещения.ДополнительныеПараметры.Элемент = Элемент;
		РезультатФильтрации = Ложь;
		ОписанияОповещений.ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатФильтрации);
		
		Если НЕ РезультатФильтрации Тогда
			Результат = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	ОчиститьВременныеОписанияОповещений();
	
	Возврат Результат;
	
КонецФункции

// Проверить, что все элементы коллекции не удовлетворяют условию в функции сравнения.
// Терминальный метод.
//
// Параметры:
//   ФункцияСравнения - Строка, ОписаниеОповещения - Функция сравнения.
//		В случае передачи Строки формируется служебное описание оповещения, в контексте которого заданы переменные
//		"Результат", "ДополнительныеПараметры", "Элемент".
//		В случае передачи ОписанияОповещения обработчик данного описания должен содержать два параметра 
//		(имена произвольные):
//			"Результат" - Булево - Переменная, в которой возвращается значение работы функции.
//			"ДополнительныеПараметры" - Структура - Структура параметров, передаваемая функции.
//
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров, передаваемая функции сравнения.
//		Служит для передачи дополнительных данных из прикладного кода в функцию сравнения.
//		По умолчанию содержит одно значение - Элемент.
//
//  Возвращаемое значение:
//   Булево - Истина, если все элементы коллекции не удовлетворяют условию Функции сравнения.
//		В обратном случае возвращает Ложь.
//		Если коллекция пустая, возвращает Истина.
//
Функция ВсеНеСоответствуют(Знач ФункцияСравнения, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Лог.Отладка("ВсеНеСоответствуют");
	
	Если ТипЗнч(ФункцияСравнения) = Тип("Строка") Тогда
		ФункцияСравнения = СформироватьВременноеОписаниеОповещения(ФункцияСравнения, ДополнительныеПараметры);
	КонецЕсли;

	ПройтиКонвейер();
	
	Коллекция = ПроцессорКоллекцийСлужебный.ПолучитьКоллекцию();
	Результат = Истина;
	
	Если ФункцияСравнения.ДополнительныеПараметры = Неопределено Тогда
		ФункцияСравнения.ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	ФункцияСравнения.ДополнительныеПараметры.Вставить("Элемент");
	
	Для Каждого Элемент Из Коллекция Цикл
		ФункцияСравнения.ДополнительныеПараметры.Элемент = Элемент;
		РезультатФильтрации = Ложь;
		ОписанияОповещений.ВыполнитьОбработкуОповещения(ФункцияСравнения, РезультатФильтрации);
		
		Если РезультатФильтрации Тогда
			Результат = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	ОчиститьВременныеОписанияОповещений();
	
	Возврат Результат;
	
КонецФункции

// Служебные процедуры и функции

Процедура ПоложитьЯчейкуВКонвейер(ИмяОперации, 
								  ВходящееОписаниеОповещения = Неопределено, 
								  ДополнительныеПараметры = Неопределено)
	
	Сообщение = ИмяОперации;
	Если ВходящееОписаниеОповещения <> Неопределено Тогда
		Сообщение = Сообщение + " " + ВходящееОписаниеОповещения.ИмяПроцедуры;
	КонецЕсли;
	Лог.Отладка(Сообщение);
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	Если ВходящееОписаниеОповещения <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("Обработчик", ВходящееОписаниеОповещения);
	КонецЕсли;

	Ячейка = ОписанияОповещений.Создать("Выполнить" + ИмяОперации, ПроцессорКоллекцийСлужебный, ДополнительныеПараметры);
	
	Конвейер.Добавить(Ячейка);
	
КонецПроцедуры

Процедура ПройтиКонвейер()

	Лог.Отладка("Прохожу по конвейеру");

	Результат = Новый Массив;
	Для Каждого Ячейка Из Конвейер Цикл
		Коллекция = ПроцессорКоллекцийСлужебный.ПолучитьКоллекцию();
		
		Лог.Отладка("Выполняю ячейку конвейера %1", Ячейка.ИмяПроцедуры);
		Лог.Отладка("Размер коллекции %1", Коллекция.Количество());

		ОписанияОповещений.ВыполнитьОбработкуОповещения(Ячейка, Результат);
		ПроцессорКоллекцийСлужебный.УстановитьКоллекцию(Результат, Ложь);
	КонецЦикла;

	Конвейер.Очистить();
	ОчиститьВременныеОписанияОповещений();

КонецПроцедуры

Функция СформироватьВременноеОписаниеОповещения(ПользовательскоеВыражение, ДополнительныеПараметры)

	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;

	ТекстИзолированногоКласса = СтрЗаменить(
		ТекстШаблонаИзолированногоКласса,
		"А = 0;",
		ПользовательскоеВыражение
	);
	
	ВременныйСценарий = ЗагрузитьСценарийИзСтроки(ТекстИзолированногоКласса);

	ОписаниеОповещения = ОписанияОповещений.Создать(
		"ОбработкаОповещения", 
		ВременныйСценарий, 
		ДополнительныеПараметры
	);
	
	ВременныеОписанияОповещений.Добавить(ВременныйСценарий);
	ВременныеОписанияОповещений.Добавить(ОписаниеОповещения);

	Возврат ОписаниеОповещения;

КонецФункции

Процедура ОчиститьВременныеОписанияОповещений()
	Для Каждого ВременныйСценарий Из ВременныеОписанияОповещений Цикл
		ОсвободитьОбъект(ВременныйСценарий);
	КонецЦикла;
	ВременныеОписанияОповещений = Новый Массив;
КонецПроцедуры

Процедура Инициализация()
	Конвейер = Новый Массив;
	ВременныеОписанияОповещений = Новый Массив;
	Лог = Логирование.ПолучитьЛог("oscript.lib.stream");

	ПроцессорКоллекцийСлужебный = Новый ПроцессорКоллекцийСлужебный();

	ТекстШаблонаИзолированногоКласса = 
	"Процедура ОбработкаОповещения(Результат, ДополнительныеПараметры) Экспорт
	|
	|	Элемент = Неопределено;
	|	Элемент1 = Неопределено;
	|	Элемент2 = Неопределено;
	|	
	|	ДополнительныеПараметры.Свойство(""Элемент"", Элемент);
	|	ДополнительныеПараметры.Свойство(""Элемент1"", Элемент1);
	|	ДополнительныеПараметры.Свойство(""Элемент2"", Элемент2);
	|	
	|	А = 0;
	|	
	|КонецПроцедуры";

КонецПроцедуры

Инициализация();
