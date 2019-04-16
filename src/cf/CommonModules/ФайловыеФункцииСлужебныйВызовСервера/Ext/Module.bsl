﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. эту процедуру в модуле ФайловыеФункцииСлужебный.
Процедура ЗаписатьРезультатИзвлеченияТекста(ФайлИлиВерсияСсылка,
                                            РезультатИзвлечения,
                                            АдресВременногоХранилищаТекста) Экспорт
	
	ФайловыеФункцииСлужебный.ЗаписатьРезультатИзвлеченияТекста(
		ФайлИлиВерсияСсылка,
		РезультатИзвлечения,
		АдресВременногоХранилищаТекста);
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ПроверитьПодписи(ИсходныеДанные, ДанныеСтрок) Экспорт
	
	ДатаПроверкиПодписи = ТекущаяДатаСеанса();
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		Возврат;
	КонецЕсли;
	МодульЭлектроннаяПодпись = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодпись");
	
	МенеджерКриптографии = МодульЭлектроннаяПодпись.МенеджерКриптографии("ПроверкаПодписи");
	
	Для каждого СтрокаПодписи Из ДанныеСтрок Цикл
		ОписаниеОшибки = "";
		ПодписьВерна = МодульЭлектроннаяПодпись.ПроверитьПодпись(МенеджерКриптографии,
			ИсходныеДанные, СтрокаПодписи.АдресПодписи, ОписаниеОшибки, СтрокаПодписи.ДатаПодписи);
		
		СтрокаПодписи.ДатаПроверкиПодписи = ТекущаяДатаСеанса();
		СтрокаПодписи.ПодписьВерна = ПодписьВерна;
		ФайловыеФункцииСлужебныйКлиентСервер.ЗаполнитьСтатусПодписи(СтрокаПодписи, ОписаниеОшибки);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает номер по нарастанию. Предыдущее значение берется из регистра сведений НомераОтсканированныхФайлов.
// Параметры:
// Владелец - ЛюбаяСсылка - владелец файла.
//
// Возвращаемое значение:
//   Число  - новый номер для сканирования.
//
Функция ПолучитьНовыйНомерДляСканирования(Владелец) Экспорт
	
	// Подготовить структуру отбора по измерениям.
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Владелец", Владелец);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НомераОтсканированныхФайлов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Владелец", Владелец);
		Блокировка.Заблокировать();
	
		// Получить структуру с данными ресурсов записи.
		СтруктураРесурсов = РегистрыСведений.НомераОтсканированныхФайлов.Получить(СтруктураОтбора);
		
		// Получить максимальный номер из регистра.
		Номер = СтруктураРесурсов.Номер;
		Номер = Номер + 1; // увеличим на 1
		
		// Запишем новый номер в регистр.
		НаборЗаписей = РегистрыСведений.НомераОтсканированныхФайлов.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Владелец.Установить(Владелец);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Владелец = Владелец;
		НоваяЗапись.Номер = Номер;
		
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Номер;
	
КонецФункции

// Заносит номер в регистр сведений НомераОтсканированныхФайлов.
//
// Параметры:
// Владелец - ЛюбаяСсылка - владелец файла.
// НовыйНомер -  Число  - максимальный номер для сканирования.
//
Процедура ЗанестиМаксимальныйНомерДляСканирования(Владелец, НовыйНомер) Экспорт
	
	// Подготовить структуру отбора по измерениям.
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Владелец", Владелец);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НомераОтсканированныхФайлов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Владелец", Владелец);
		Блокировка.Заблокировать();   		
		
		// Получить структуру с данными ресурсов записи.
		СтруктураРесурсов = РегистрыСведений.НомераОтсканированныхФайлов.Получить(СтруктураОтбора);
		   
		// Получить максимальный номер из регистра.
		Номер = СтруктураРесурсов.Номер;
		Если НовыйНомер <= Номер Тогда // Кто-то другой уже записал бОльший номер.
			ОтменитьТранзакцию();
			Возврат;
		КонецЕсли;
		
		Номер = НовыйНомер;
		
		// Запишем новый номер в регистр.
		НаборЗаписей = РегистрыСведений.НомераОтсканированныхФайлов.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Владелец.Установить(Владелец);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Владелец = Владелец;
		НоваяЗапись.Номер = Номер;
		
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Функция ДанныеФайлаИДвоичныеДанные(ФайлВложение, Параметры) Экспорт
	
	Если Параметры.ЭтоФайл И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		
		МодульРаботаСФайламиСлужебныйВызовСервера = ОбщегоНазначения.ОбщийМодуль("РаботаСФайламиСлужебныйВызовСервера");
		ДанныеФайлаИДвоичныеДанные = МодульРаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаИДвоичныеДанные(ФайлВложение);
		ДанныеФайла = ДанныеФайлаИДвоичныеДанные.ДанныеФайла;
		ДвоичныеДанные = ДанныеФайлаИДвоичныеДанные.ДвоичныеДанные;
		ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.Расширение);
		ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, Параметры.ИдентификаторФормы);
		ОписаниеФайла = Новый Структура;
		ОписаниеФайла.Вставить("Представление", ИмяФайла);
		ОписаниеФайла.Вставить("АдресВоВременномХранилище", ПутьВоВременномХранилище);
		
		Возврат ОписаниеФайла;
		
	КонецЕсли;
	
	Если Не Параметры.ЭтоФайл И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрисоединенныеФайлы") Тогда
		
		МодульПрисоединенныеФайлыСлужебныйВызовСервера = ОбщегоНазначения.ОбщийМодуль("ПрисоединенныеФайлыСлужебныйВызовСервера");
		ДанныеФайлаИДвоичныеДанные = МодульПрисоединенныеФайлыСлужебныйВызовСервера.ПолучитьДанныеФайла(ФайлВложение, Параметры.ИдентификаторФормы);
		ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(ДанныеФайлаИДвоичныеДанные.Наименование, ДанныеФайлаИДвоичныеДанные.Расширение);
		ОписаниеФайла = Новый Структура;
		ОписаниеФайла.Вставить("Представление", ИмяФайла);
		ОписаниеФайла.Вставить("АдресВоВременномХранилище", ДанныеФайлаИДвоичныеДанные.СсылкаНаДвоичныеДанныеФайла);
		
		Возврат ОписаниеФайла;
		
	КонецЕсли;

КонецФункции

Функция ПоместитьФайлыВоВременноеХранилище(Параметры) Экспорт
	
	Перем ЗаписьZipФайла, ИмяАрхива;
	
	Результат = Новый Массив;
	
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременнойПапки);
	ИспользованныеИменаФайлов = Новый Соответствие;
	
	Для Каждого ФайлВложение Из Параметры.МассивФайлов Цикл
		ОписаниеФайла = ДанныеФайлаИДвоичныеДанные(ФайлВложение, Параметры);
		Результат.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
