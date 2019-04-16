﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.РежимОткрытияОкна <> Неопределено Тогда
		РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли;
	
	Если Параметры.ТабличныйДокумент = Неопределено Тогда
		Если Не ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета) Тогда
			ЗагрузитьТабличныйДокументИзМетаданных();
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Параметры.ТабличныйДокумент) = Тип("ТабличныйДокумент") Тогда
		ТабличныйДокумент = Параметры.ТабличныйДокумент;
	Иначе
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(Параметры.ТабличныйДокумент);
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("mxl");
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		ТабличныйДокумент.Прочитать(ИмяВременногоФайла);
		УдалитьФайлы(ИмяВременногоФайла);
	КонецЕсли;
	
	Элементы.ТабличныйДокумент.Редактирование = Параметры.Редактирование;
	Элементы.ТабличныйДокумент.ОтображатьГруппировки = Истина;
	
	ЭтоМакет = Не ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета);
	Элементы.Предупреждение.Видимость = ЭтоМакет И Параметры.Редактирование;
	
	Элементы.РедактироватьВоВнешнейПрограмме.Видимость = ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() 
		И Не ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета) И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать");
	
	Если Не ПустаяСтрока(Параметры.ИмяДокумента) Тогда
		ИмяДокумента = Параметры.ИмяДокумента;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(Параметры.ПутьКФайлу) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииИнициализацииФайла", ЭтотОбъект);
		Файл = Новый Файл();
		Файл.НачатьИнициализацию(ОписаниеОповещения, Параметры.ПутьКФайлу);
		Возврат;
	КонецЕсли;
	
	УстановитьНачальныеНастройкиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сохранить изменения в %1?'"), ИмяДокумента);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодтвердитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОписаниеОповещения, Отказ, ТекстВопроса);
	
	Если Не Модифицированность Тогда
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ПутьКФайлу", Параметры.ПутьКФайлу);
		ПараметрыОповещения.Вставить("ИмяОбъектаМетаданныхМакета", Параметры.ИмяОбъектаМетаданныхМакета);
		Если ЗаписьВыполнена Тогда
			ИмяСобытия = "Запись_ТабличныйДокумент";
			ПараметрыОповещения.Вставить("ТабличныйДокумент", ТабличныйДокумент);
		Иначе
			ИмяСобытия = "ОтменаРедактированияТабличногоДокумента";
		КонецЕсли;
		Оповестить(ИмяСобытия, ПараметрыОповещения, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытьФормуПослеЗаписиТабличногоДокумента", ЭтотОбъект);
	ЗаписатьТабличныйДокумент(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗапросИменРедактируемыхТабличныхДокументов" И Источник <> ЭтотОбъект Тогда
		Параметр.Добавить(ИмяДокумента);
	ИначеЕсли ИмяСобытия = "ЗакрытиеФормыВладельца" И Источник = ВладелецФормы Тогда
		Закрыть();
		Если Открыта() Тогда
			Параметр.Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТабличныйДокументПриАктивизацииОбласти(Элемент)
	ОбновитьПометкиКнопокКоманднойПанели();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Действия с документом

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытьФормуПослеЗаписиТабличногоДокумента", ЭтотОбъект);
	ЗаписатьТабличныйДокумент(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьТабличныйДокумент();
КонецПроцедуры

&НаКлиенте
Процедура Редактирование(Команда)
	Элементы.ТабличныйДокумент.Редактирование = Не Элементы.ТабличныйДокумент.Редактирование;
	НастроитьПредставлениеКоманд();
	НастроитьОтображениеТабличногоДокумента();
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьВоВнешнейПрограмме(Команда)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТабличныйДокумент", ТабличныйДокумент);
		ПараметрыОткрытия.Вставить("ИмяОбъектаМетаданныхМакета", Параметры.ИмяОбъектаМетаданныхМакета);
		ПараметрыОткрытия.Вставить("ТипМакета", "MXL");
		ОписаниеОповещения = Новый ОписаниеОповещения("РедактироватьВоВнешнейПрограммеЗавершение", ЭтотОбъект);
		МодульУправлениеПечатьюКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеПечатьюКлиент");
		МодульУправлениеПечатьюКлиент.РедактироватьМакетВоВнешнейПрограмме(ОписаниеОповещения, ПараметрыОткрытия, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

// Форматирование

&НаКлиенте
Процедура УвеличитьРазмерШрифта(Команда)
	
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Размер = Область.Шрифт.Размер;
		Размер = Размер + ШагИзмененияРазмераШрифтаУвеличение(Размер);
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,Размер);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшитьРазмерШрифта(Команда)
	
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Размер = Область.Шрифт.Размер;
		Размер = Размер - ШагИзмененияРазмераШрифтаУменьшение(Размер);
		Если Размер < 1 Тогда
			Размер = 1;
		КонецЕсли;
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,Размер);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Зачеркивание(Команда)
	
	УстанавливаемоеЗначение = Неопределено;
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Если УстанавливаемоеЗначение = Неопределено Тогда
			УстанавливаемоеЗначение = Не Область.Шрифт.Зачеркивание = Истина;
		КонецЕсли;
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,,,,,УстанавливаемоеЗначение);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьТабличныйДокументИзМетаданных()
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		ТабличныйДокумент = МодульУправлениеПечатью.МакетПечатнойФормы(Параметры.ИмяОбъектаМетаданныхМакета);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтображениеТабличногоДокумента()
	Элементы.ТабличныйДокумент.ОтображатьЗаголовки = Элементы.ТабличныйДокумент.Редактирование;
	Элементы.ТабличныйДокумент.ОтображатьСетку = Элементы.ТабличныйДокумент.Редактирование;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПометкиКнопокКоманднойПанели();
	
	#Если Не ВебКлиент Тогда
	Область = Элементы.ТабличныйДокумент.ТекущаяОбласть;
	Если ТипЗнч(Область) <> Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		Возврат;
	КонецЕсли;
	
	// Шрифт
	Шрифт = Область.Шрифт;
	Элементы.ТабличныйДокументЖирный.Пометка = Шрифт <> Неопределено И Шрифт.Жирный = Истина;
	Элементы.ТабличныйДокументНаклонный.Пометка = Шрифт <> Неопределено И Шрифт.Наклонный = Истина;
	Элементы.ТабличныйДокументПодчеркивание.Пометка = Шрифт <> Неопределено И Шрифт.Подчеркивание = Истина;
	Элементы.Зачеркивание.Пометка = Шрифт <> Неопределено И Шрифт.Зачеркивание = Истина;
	
	// Горизонтальное положение
	Элементы.ТабличныйДокументВыровнятьВлево.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
	Элементы.ТабличныйДокументВыровнятьПоЦентру.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	Элементы.ТабличныйДокументВыровнятьВправо.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;
	Элементы.ТабличныйДокументВыровнятьПоШирине.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.ПоШирине;
	
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция ШагИзмененияРазмераШрифтаУвеличение(Размер)
	Если Размер = -1 Тогда
		Возврат 10;
	КонецЕсли;
	
	Если Размер < 10 Тогда
		Возврат 1;
	ИначеЕсли 10 <= Размер И  Размер < 20 Тогда
		Возврат 2;
	ИначеЕсли 20 <= Размер И  Размер < 48 Тогда
		Возврат 4;
	ИначеЕсли 48 <= Размер И  Размер < 72 Тогда
		Возврат 6;
	ИначеЕсли 72 <= Размер И  Размер < 96 Тогда
		Возврат 8;
	Иначе
		Возврат Окр(Размер / 10);
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция ШагИзмененияРазмераШрифтаУменьшение(Размер)
	Если Размер = -1 Тогда
		Возврат -8;
	КонецЕсли;
	
	Если Размер <= 11 Тогда
		Возврат 1;
	ИначеЕсли 11 < Размер И Размер <= 23 Тогда
		Возврат 2;
	ИначеЕсли 23 < Размер И Размер <= 53 Тогда
		Возврат 4;
	ИначеЕсли 53 < Размер И Размер <= 79 Тогда
		Возврат 6;
	ИначеЕсли 79 < Размер И Размер <= 105 Тогда
		Возврат 8;
	Иначе
		Возврат Окр(Размер / 11);
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция СписокОбластейДляИзмененияШрифта()
	
	Результат = Новый Массив;
	
	Для Каждого ОбрабатываемаяОбласть Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		Если ОбрабатываемаяОбласть.Шрифт <> Неопределено Тогда
			Результат.Добавить(ОбрабатываемаяОбласть);
			Продолжить;
		КонецЕсли;
		
		ОбрабатываемаяОбластьВерх = ОбрабатываемаяОбласть.Верх;
		ОбрабатываемаяОбластьНиз = ОбрабатываемаяОбласть.Низ;
		ОбрабатываемаяОбластьЛево = ОбрабатываемаяОбласть.Лево;
		ОбрабатываемаяОбластьПраво = ОбрабатываемаяОбласть.Право;
		
		Если ОбрабатываемаяОбластьВерх = 0 Тогда
			ОбрабатываемаяОбластьВерх = 1;
		КонецЕсли;
		
		Если ОбрабатываемаяОбластьНиз = 0 Тогда
			ОбрабатываемаяОбластьНиз = ТабличныйДокумент.ВысотаТаблицы;
		КонецЕсли;
		
		Если ОбрабатываемаяОбластьЛево = 0 Тогда
			ОбрабатываемаяОбластьЛево = 1;
		КонецЕсли;
		
		Если ОбрабатываемаяОбластьПраво = 0 Тогда
			ОбрабатываемаяОбластьПраво = ТабличныйДокумент.ШиринаТаблицы;
		КонецЕсли;
		
		Если ОбрабатываемаяОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Колонки Тогда
			ОбрабатываемаяОбластьВерх = ОбрабатываемаяОбласть.Низ;
			ОбрабатываемаяОбластьНиз = ТабличныйДокумент.ВысотаТаблицы;
		КонецЕсли;
			
		Для НомерКолонки = ОбрабатываемаяОбластьЛево По ОбрабатываемаяОбластьПраво Цикл
			ШиринаКолонки = Неопределено;
			Для НомерСтроки = ОбрабатываемаяОбластьВерх По ОбрабатываемаяОбластьНиз Цикл
				Ячейка = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
				Если ОбрабатываемаяОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Колонки Тогда
					Если ШиринаКолонки = Неопределено Тогда
						ШиринаКолонки = Ячейка.ШиринаКолонки;
					КонецЕсли;
					Если Ячейка.ШиринаКолонки <> ШиринаКолонки Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				Если Ячейка.Шрифт <> Неопределено Тогда
					Результат.Добавить(Ячейка);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьФормуПослеЗаписиТабличногоДокумента(Закрывать, ДополнительныеПараметры) Экспорт
	Если Закрывать Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТабличныйДокумент(ОбработчикЗавершения = Неопределено)
	
	Если ЭтоНовый() Или РедактированиеЗапрещено Тогда
		НачатьДиалогСохраненияФайла(ОбработчикЗавершения);
		Возврат;
	КонецЕсли;
		
	ЗаписатьТабличныйДокументИмяФайлаВыбрано(ОбработчикЗавершения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТабличныйДокументИмяФайлаВыбрано(Знач ОбработчикЗавершения)
	
	Если Не ПустаяСтрока(Параметры.ПутьКФайлу) Тогда
		ТабличныйДокумент.Записать(Параметры.ПутьКФайлу);
		РедактированиеЗапрещено = Ложь;
	КонецЕсли;
	
	ЗаписьВыполнена = Истина;
	Модифицированность = Ложь;
	УстановитьЗаголовок();
	
	ВыполнитьОбработкуОповещения(ОбработчикЗавершения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьДиалогСохраненияФайла(Знач ОбработчикЗавершения)
	
	Перем ДиалогСохраненияФайла, ОписаниеОповещения;
	
	ДиалогСохраненияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогСохраненияФайла.ПолноеИмяФайла = ИмяДокумента;
	ДиалогСохраненияФайла.Фильтр = НСтр("ru = 'Табличный документ'") + " (*.mxl)|*.mxl";
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииДиалогаВыбораФайла", ЭтотОбъект, ОбработчикЗавершения);
	ДиалогСохраненияФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииДиалогаВыбораФайла(ВыбранныеФайлы, ОбработчикЗавершения) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолноеИмяФайла = ВыбранныеФайлы[0];
	
	Параметры.ПутьКФайлу = ПолноеИмяФайла;
	ИмяДокумента = Сред(ПолноеИмяФайла, СтрДлина(ОписаниеФайла(ПолноеИмяФайла).Путь) + 1);
	Если НРег(Прав(ИмяДокумента, 4)) = ".mxl" Тогда
		ИмяДокумента = Лев(ИмяДокумента, СтрДлина(ИмяДокумента) - 4);
	КонецЕсли;
	
	ЗаписатьТабличныйДокументИмяФайлаВыбрано(ОбработчикЗавершения);
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеФайла(ПолноеИмя)
	
	ПозицияРазделителя = СтрНайти(ПолноеИмя, ПолучитьРазделительПути(), НаправлениеПоиска.СКонца);
	
	Имя = Сред(ПолноеИмя, ПозицияРазделителя + 1);
	Путь = Лев(ПолноеИмя, ПозицияРазделителя);
	
	ПозицияРасширения = СтрНайти(Имя, ".", НаправлениеПоиска.СКонца);
	
	ИмяБезРасширения = Лев(Имя, ПозицияРасширения - 1);
	Расширение = Сред(Имя, ПозицияРасширения + 1);
	
	Результат = Новый Структура;
	Результат.Вставить("ПолноеИмя", ПолноеИмя);
	Результат.Вставить("Имя", Имя);
	Результат.Вставить("Путь", Путь);
	Результат.Вставить("ИмяБезРасширения", ИмяБезРасширения);
	Результат.Вставить("Расширение", Расширение);
	
	Возврат Результат;
	
КонецФункции
	
&НаКлиенте
Функция ИмяНовогоДокумента()
	Возврат НСтр("ru = 'Новый'");
КонецФункции

&НаКлиенте
Процедура УстановитьЗаголовок()
	
	Заголовок = ИмяДокумента;
	Если ЭтоНовый() Тогда
		Заголовок = Заголовок + " (" + НСтр("ru = 'создание'") + ")";
	ИначеЕсли РедактированиеЗапрещено Тогда
		Заголовок = Заголовок + " (" + НСтр("ru = 'только просмотр'") + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПредставлениеКоманд()
	
	ДокументРедактируется = Элементы.ТабличныйДокумент.Редактирование;
	Элементы.Редактирование.Пометка = ДокументРедактируется;
	Элементы.КомандыРедактирования.Доступность = ДокументРедактируется;
	Элементы.ЗаписатьИЗакрыть.Доступность = ДокументРедактируется Или Модифицированность;
	Элементы.Записать.Доступность = ДокументРедактируется Или Модифицированность;
	
	Если ДокументРедактируется И Не ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета) Тогда
		Элементы.Предупреждение.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоНовый()
	Возврат ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета) И ПустаяСтрока(Параметры.ПутьКФайлу);
КонецФункции

&НаКлиенте
Процедура РедактироватьВоВнешнейПрограммеЗавершение(ЗагруженныйТабличныйДокумент, ДополнительныеПараметры) Экспорт
	Если ЗагруженныйТабличныйДокумент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	ОбновитьТабличныйДокумент(ЗагруженныйТабличныйДокумент);
КонецПроцедуры

&НаСервере
Процедура ОбновитьТабличныйДокумент(ЗагруженныйТабличныйДокумент)
	ТабличныйДокумент = ЗагруженныйТабличныйДокумент;
КонецПроцедуры


&НаКлиенте
Процедура УстановитьНачальныеНастройкиФормы()
	
	Если Не ПустаяСтрока(Параметры.ПутьКФайлу) И Не РедактированиеЗапрещено Тогда
		Элементы.ТабличныйДокумент.Редактирование = Истина;
	КонецЕсли;
	
	УстановитьИмяДокумента();
	УстановитьЗаголовок();
	НастроитьПредставлениеКоманд();
	НастроитьОтображениеТабличногоДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИмяДокумента()

	Если ПустаяСтрока(ИмяДокумента) Тогда
		ИспользованныеИмена = Новый Массив;
		Оповестить("ЗапросИменРедактируемыхТабличныхДокументов", ИспользованныеИмена, ЭтотОбъект);
		
		Индекс = 1;
		Пока ИспользованныеИмена.Найти(ИмяНовогоДокумента() + Индекс) <> Неопределено Цикл
			Индекс = Индекс + 1;
		КонецЦикла;
		
		ИмяДокумента = ИмяНовогоДокумента() + Индекс;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииИнициализацииФайла(Файл, ДополнительныеПараметры) Экспорт
	
	Если ПустаяСтрока(ИмяДокумента) Тогда
		ИмяДокумента = Файл.ИмяБезРасширения;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииПолученияТолькоЧтения", ЭтотОбъект);
	Файл.НачатьПолучениеТолькоЧтения(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииПолученияТолькоЧтения(ТолькоЧтение, ДополнительныеПараметры) Экспорт
	
	РедактированиеЗапрещено = ТолькоЧтение;
	УстановитьНачальныеНастройкиФормы();
	
КонецПроцедуры

#КонецОбласти
