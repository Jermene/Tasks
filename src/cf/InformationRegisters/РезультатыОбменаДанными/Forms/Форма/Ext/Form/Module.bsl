﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользуетсяГрупповоеИзменение = Ложь;
	ОбменДаннымиСервер.ПриОпределенииИспользованияГрупповогоИзмененияОбъектов(ИспользуетсяГрупповоеИзменение);
	
	Если Не ИспользуетсяГрупповоеИзменение Тогда
		
		Элементы.НепроведенныеДокументыКонтекстноеМеню.ПодчиненныеЭлементы.НепроведенныеДокументыКонтекстноеМенюИзменитьВыделенныеДокументы.Видимость = Ложь;
		Элементы.НепроведенныеДокументыИзменитьВыделенныеДокументы.Видимость = Ложь;
		Элементы.НезаполненныеРеквизитыКонтекстноеМеню.ПодчиненныеЭлементы.НезаполненныеРеквизитыКонтекстноеМенюИзменитьВыделенныеОбъекты.Видимость = Ложь;
		Элементы.НезаполненныеРеквизитыИзменитьВыделенныеОбъекты.Видимость = Ложь;
		
	КонецЕсли;
	
	ИспользуетсяДатыЗапретаИзменения = Ложь;
	ОбменДаннымиСервер.ПриОпределенииИспользованияДатЗапретаИзменения(ИспользуетсяДатыЗапретаИзменения);
	
	ИспользуетсяВерсионирование = ОбменДаннымиПовтИсп.ИспользуетсяВерсионирование(, Истина);
	Если ИспользуетсяВерсионирование Тогда
		
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ИнициализацияДинамическогоСпискаПроблемныхВерсий(Коллизии, "Коллизии");
		
		Если ИспользуетсяДатыЗапретаИзменения Тогда
			МодульВерсионированиеОбъектов.ИнициализацияДинамическогоСпискаПроблемныхВерсий(НепринятыеПоДате, "НепринятыеПоДате");
		КонецЕсли;
	КонецЕсли;
	
	Элементы.СтраницаКоллизии.Видимость = ИспользуетсяВерсионирование;
	Элементы.СтраницаНепринятыеПоДатеЗапрета.Видимость = ИспользуетсяВерсионирование И ИспользуетсяДатыЗапретаИзменения;
	
	// Устанавливаем отборы динамических списков и сохраняем их в реквизите для управления ими.
	НастроитьОтборыДинамическихСписков(НастройкиОтборовДинамическихСписков);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ИспользуетсяВерсионирование Тогда
		
		Элементы.КоллизииАвторДругойВерсии.Заголовок = НСтр("ru = 'Версия получена из приложения'");
		
	КонецЕсли;
	
	ЗаполнитьСписокУзлов();
	
	ОбновитьОтборыИПроигнорированные();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить("ЗакрытаФормаРезультатовОбменаДанными");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбновитьОтборыИПроигнорированные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ОбновитьОтборПоПричине();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ОбновитьОтборПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура УзелИнформационнойБазыОчистка(Элемент, СтандартнаяОбработка)
	
	УзелИнформационнойБазы = Неопределено;
	ОбновитьОтборПоУзлу();
	
КонецПроцедуры

&НаКлиенте
Процедура УзелИнформационнойБазыПриИзменении(Элемент)
	
	ОбновитьОтборПоУзлу();
	
КонецПроцедуры

&НаКлиенте
Процедура УзелИнформационнойБазыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Не Элементы.УзелИнформационнойБазы.РежимВыбораИзСписка Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Обработчик = Новый ОписаниеОповещения("УзелИнформационнойБазыНачалоВыбораЗавершение", ЭтотОбъект);
		Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		ОткрытьФорму("ОбщаяФорма.ВыборУзловПлановОбмена",,,,,, Обработчик, Режим);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УзелИнформационнойБазыНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	УзелИнформационнойБазы = РезультатЗакрытия;
	
	ОбновитьОтборПоУзлу();
	
КонецПроцедуры

&НаКлиенте
Процедура УзелИнформационнойБазыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УзелИнформационнойБазы = ВыбранноеЗначение;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатыОбменаДаннымиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если Элемент.ПодчиненныеЭлементы.СтраницаКоллизии = ТекущаяСтраница Тогда
		Элементы.СтрокаПоиска.Доступность = Ложь;
	Иначе
		Элементы.СтрокаПоиска.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНепроведенныеДокументы

&НаКлиенте
Процедура НепроведенныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьОбъект(Элементы.НепроведенныеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура НепроведенныеДокументыПередНачаломИзменения(Элемент, Отказ)
	
	ИзменениеОбъекта();
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНезаполненныеРеквизиты

&НаКлиенте
Процедура НезаполненныеРеквизитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьОбъект(Элементы.НезаполненныеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура НезаполненныеРеквизитыПередНачаломИзменения(Элемент, Отказ)
	
	ИзменениеОбъекта();
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КоллизииПередНачаломИзменения(Элемент, Отказ)
	
	ИзменениеОбъекта();
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КоллизииПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		Если Элемент.ТекущиеДанные.ДругаяВерсияПринята Тогда
			
			ПричинаКонфликта = НСтр("ru = 'Конфликт был разрешен автоматически в пользу программы ""%1"".
				|Версия в этой программе была заменена на версию из другой программы.'");
			ПричинаКонфликта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПричинаКонфликта, Элемент.ТекущиеДанные.АвторДругойВерсии);
			
		Иначе
			
			ПричинаКонфликта =НСтр("ru = 'Конфликт был разрешен автоматически в пользу этой программы.
				|Версия в этой программе была сохранена, версия из другой программы была отклонена.'");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НепринятыеПоДатеПередНачаломИзменения(Элемент, Отказ)
	
	ИзменениеОбъекта();
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НепринятыеПоДатеПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		Если Элемент.ТекущиеДанные.НовыйОбъект Тогда
			
			Элементы.НепринятыеПоДатеПринятьВерсию.Доступность = Ложь;
			
		Иначе
			
			Элементы.НепринятыеПоДатеПринятьВерсию.Доступность = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	
	ИзменениеОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ИгнорироватьДокумент(Команда)
	
	Игнорировать(Элементы.НепроведенныеДокументы.ВыделенныеСтроки, Истина, "НепроведенныеДокументы");
	
КонецПроцедуры

&НаКлиенте
Процедура НеИгнорироватьДокумент(Команда)
	
	Игнорировать(Элементы.НепроведенныеДокументы.ВыделенныеСтроки, Ложь, "НепроведенныеДокументы");
	
КонецПроцедуры

&НаКлиенте
Процедура НеИгнорироватьОбъект(Команда)
	
	Игнорировать(Элементы.НезаполненныеРеквизиты.ВыделенныеСтроки, Ложь, "НезаполненныеРеквизиты");
	
КонецПроцедуры

&НаКлиенте
Процедура ИгнорироватьОбъект(Команда)
	
	Игнорировать(Элементы.НезаполненныеРеквизиты.ВыделенныеСтроки, Истина, "НезаполненныеРеквизиты");
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенныеДокументы(Команда)
	
	ОбменДаннымиКлиент.ПриИзмененииВыделенныхОбъектов(Элементы.НепроведенныеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОчиститьСообщения();
	ПровестиДокументы(Элементы.НепроведенныеДокументы.ВыделенныеСтроки);
	ОбновитьНаСервере("НепроведенныеДокументы");
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенныеОбъекты(Команда)
	
	ОбменДаннымиКлиент.ПриИзмененииВыделенныхОбъектов(Элементы.НезаполненныеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтличияНепринятые(Команда)
	
	ПоказатьОтличия(Элементы.НепринятыеПоДате);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюНепринятые(Команда)
	
	Если Элементы.НепринятыеПоДате.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СравниваемыеВерсии = Новый Массив;
	СравниваемыеВерсии.Добавить(Элементы.НепринятыеПоДате.ТекущиеДанные.НомерДругойВерсии);
	ОбменДаннымиКлиент.ПриОткрытииФормыОтчетаПоВерсии(Элементы.НепринятыеПоДате.ТекущиеДанные.Ссылка, СравниваемыеВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюНепринятыеВЭтойПрограмме(Команда)
	
	Если Элементы.НепринятыеПоДате.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СравниваемыеВерсии = Новый Массив;
	СравниваемыеВерсии.Добавить(Элементы.НепринятыеПоДате.ТекущиеДанные.НомерЭтойВерсии);
	ОбменДаннымиКлиент.ПриОткрытииФормыОтчетаПоВерсии(Элементы.НепринятыеПоДате.ТекущиеДанные.Ссылка, СравниваемыеВерсии);

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтличияКоллизии(Команда)
	
	ПоказатьОтличия(Элементы.Коллизии);
	
КонецПроцедуры

&НаКлиенте
Процедура ИгнорироватьКонфликт(Команда)
	
	ИгнорироватьВерсию(Элементы.Коллизии.ВыделенныеСтроки, Истина, "Коллизии");
	
КонецПроцедуры

&НаКлиенте
Процедура ИгнорироватьНепринятый(Команда)
	
	ИгнорироватьВерсию(Элементы.НепринятыеПоДате.ВыделенныеСтроки, Истина, "НепринятыеПоДате");
	
КонецПроцедуры

&НаКлиенте
Процедура НеИгнорироватьКонфликт(Команда)
	
	ИгнорироватьВерсию(Элементы.Коллизии.ВыделенныеСтроки, Ложь, "Коллизии");
	
КонецПроцедуры

&НаКлиенте
Процедура НеИгнорироватьНепринятый(Команда)
	
	ИгнорироватьВерсию(Элементы.НепринятыеПоДате.ВыделенныеСтроки, Ложь, "НепринятыеПоДате");
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВерсиюНепринятые(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПринятьВерсиюНепринятыеЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Принять версию, несмотря на запрет загрузки?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВерсиюНепринятыеЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПринятьОтклонитьВерсиюНаСервере(Элементы.НепринятыеПоДате.ВыделенныеСтроки, "НепринятыеПоДате");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюДоКонфликта(Команда)
	
	ТекущиеДанные = Элементы.Коллизии.ТекущиеДанные;
	ОткрытьВерсиюНаКлиенте(Элементы.Коллизии.ТекущиеДанные, ТекущиеДанные.НомерЭтойВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюКонфликта(Команда)
	
	ТекущиеДанные = Элементы.Коллизии.ТекущиеДанные;
	ОткрытьВерсиюНаКлиенте(Элементы.Коллизии.ТекущиеДанные, ТекущиеДанные.НомерДругойВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПроигнорированныеКонфликты(Команда)
	
	ПоказыватьПроигнорированныеКонфликты = Не ПоказыватьПроигнорированныеКонфликты;
	ПоказыватьПроигнорированныеКонфликтыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПроигнорированныеНезаполненные(Команда)
	
	ПоказыватьПроигнорированныеНезаполненные = Не ПоказыватьПроигнорированныеНезаполненные;
	ПоказыватьПроигнорированныеНезаполненныеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПроигнорированныеНепринятые(Команда)
	
	ПоказыватьПроигнорированныеНепринятые = Не ПоказыватьПроигнорированныеНепринятые;
	ПоказыватьПроигнорированныеНепринятыеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПроигнорированныеНепроведенные(Команда)
	
	ПоказыватьПроигнорированныеНепроведенные = Не ПоказыватьПроигнорированныеНепроведенные;
	ПоказыватьПроигнорированныеНепроведенныеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРезультатКонфликта(Команда)
	
	Если Элементы.Коллизии.ТекущиеДанные <> Неопределено Тогда
		
		Если Элементы.Коллизии.ТекущиеДанные.ДругаяВерсияПринята Тогда
			
			ТекстВопроса = НСтр("ru = 'Заменить версию, полученную из другой программы, на версию из этой программы?'");
			
		Иначе
			
			ТекстВопроса = НСтр("ru = 'Заменить версию этой программы на версию, полученную из другой программы?'");
			
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРезультатКонфликтаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРезультатКонфликтаЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ПринятьОтклонитьВерсиюНаСервере(Элементы.Коллизии.ВыделенныеСтроки, "Коллизии");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Игнорировать(Знач ВыделенныеСтроки, Пропустить, ИмяЭлемента)
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
	
		РегистрыСведений.РезультатыОбменаДанными.Игнорировать(ВыделеннаяСтрока.ПроблемныйОбъект, ВыделеннаяСтрока.ТипПроблемы, Пропустить);
	
	КонецЦикла;
	
	ОбновитьНаСервере(ИмяЭлемента);
	
КонецПроцедуры


&НаСервере
Процедура ПоказыватьПроигнорированныеКонфликтыНаСервере(Обновлять = Истина)
	
	Элементы.КоллизииПоказыватьПроигнорированныеКонфликты.Пометка = ПоказыватьПроигнорированныеКонфликты;
	
	Отбор = Коллизии.КомпоновщикНастроек.Настройки.Отбор;
	ЭлементОтбора = Отбор.ПолучитьОбъектПоИдентификатору( НастройкиОтборовДинамическихСписков.Коллизии.ВерсияПроигнорирована );
	ЭлементОтбора.ПравоеЗначение = ПоказыватьПроигнорированныеКонфликты;
	ЭлементОтбора.Использование  = Не ПоказыватьПроигнорированныеКонфликты;
	
	Если Обновлять Тогда
		ОбновитьНаСервере("Коллизии");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказыватьПроигнорированныеНезаполненныеНаСервере(Обновлять = Истина)
	
	Элементы.НезаполненныеРеквизитыПоказыватьПроигнорированныеНезаполненные.Пометка = ПоказыватьПроигнорированныеНезаполненные;
	
	Отбор = НезаполненныеРеквизиты.КомпоновщикНастроек.Настройки.Отбор;
	ЭлементОтбора = Отбор.ПолучитьОбъектПоИдентификатору( НастройкиОтборовДинамическихСписков.НезаполненныеРеквизиты.Пропущена );
	ЭлементОтбора.ПравоеЗначение = ПоказыватьПроигнорированныеНезаполненные;
	ЭлементОтбора.Использование  = Не ПоказыватьПроигнорированныеНезаполненные;
	
	Если Обновлять Тогда
		ОбновитьНаСервере("НезаполненныеРеквизиты");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказыватьПроигнорированныеНепринятыеНаСервере(Обновлять = Истина)
	
	Элементы.НепринятыеПоДатеПоказыватьПроигнорированныеНепринятые.Пометка = ПоказыватьПроигнорированныеНепринятые;
	
	Отбор = НепринятыеПоДате.КомпоновщикНастроек.Настройки.Отбор;
	ЭлементОтбора = Отбор.ПолучитьОбъектПоИдентификатору( НастройкиОтборовДинамическихСписков.НепринятыеПоДате.ВерсияПроигнорирована );
	ЭлементОтбора.ПравоеЗначение = ПоказыватьПроигнорированныеНепринятые;
	ЭлементОтбора.Использование  = Не ПоказыватьПроигнорированныеНепринятые;
	
	Если Обновлять Тогда
		ОбновитьНаСервере("НепринятыеПоДате");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказыватьПроигнорированныеНепроведенныеНаСервере(Обновлять = Истина)
	
	Элементы.НепроведенныеДокументыПоказыватьПроигнорированныеНепроведенные.Пометка = ПоказыватьПроигнорированныеНепроведенные;
	
	Отбор = НепроведенныеДокументы.КомпоновщикНастроек.Настройки.Отбор;
	ЭлементОтбора = Отбор.ПолучитьОбъектПоИдентификатору( НастройкиОтборовДинамическихСписков.НепроведенныеДокументы.Пропущена );
	ЭлементОтбора.ПравоеЗначение = ПоказыватьПроигнорированныеНепроведенные;
	ЭлементОтбора.Использование  = Не ПоказыватьПроигнорированныеНепроведенные;
	
	Если Обновлять Тогда
		ОбновитьНаСервере("НепроведенныеДокументы");
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПровестиДокументы(Знач ВыделенныеСтроки)
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ДокументОбъект = ВыделеннаяСтрока.ПроблемныйОбъект.ПолучитьОбъект();
		
		Если ДокументОбъект.ПроверитьЗаполнение() Тогда
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокУзлов()
	
	ОтсутствуетОбменПоПравилам = Истина;
	КонтекстноеОткрытие = ЗначениеЗаполнено(Параметры.УзлыОбмена);
	
	УзлыОбмена = ?(КонтекстноеОткрытие, Параметры.УзлыОбмена, МассивУзловПриНеконтекстномОткрытии());
	Элементы.УзелИнформационнойБазы.СписокВыбора.ЗагрузитьЗначения(УзлыОбмена);
	
	Для Каждого УзелОбмена Из УзлыОбмена Цикл
		
		Если ОбменДаннымиПовтИсп.ЭтоУзелУниверсальногоОбменаДанными(УзелОбмена) Тогда
			
			ОтсутствуетОбменПоПравилам = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если КонтекстноеОткрытие Тогда
		
		УстановитьОтборПоУзлам(УзлыОбмена);
		СписокУзлов = Новый СписокЗначений;
		СписокУзлов.ЗагрузитьЗначения(УзлыОбмена);
		
	КонецЕсли;
	
	Если КонтекстноеОткрытие И УзлыОбмена.Количество() = 1 Тогда
		
		УзелИнформационнойБазы = Неопределено;
		Элементы.УзелИнформационнойБазы.Видимость = Ложь;
		Элементы.НепроведенныеДокументыУзелИнформационнойБазы.Видимость = Ложь;
		Элементы.НезаполненныеРеквизитыУзелИнформационнойБазы.Видимость = Ложь;
		
		Если ИспользуетсяВерсионирование Тогда
			Элементы.КоллизииАвторДругойВерсии.Видимость = Ложь;
			Элементы.НепринятыеПоДатеАвторДругойВерсии.Видимость = Ложь;
		КонецЕсли;
		
	ИначеЕсли УзлыОбмена.Количество() >= 7 Тогда
		
		Элементы.УзелИнформационнойБазы.РежимВыбораИзСписка = Ложь;
		
	КонецЕсли;
	
	Если КонтекстноеОткрытие И ОтсутствуетОбменПоПравилам Тогда
		Заголовок = НСтр("ru = 'Конфликты при синхронизации данных'");
		Элементы.СтрокаПоиска.Видимость = Ложь;
		Элементы.РезультатыОбменаДанными.ТекущаяСтраница = Элементы.РезультатыОбменаДанными.ПодчиненныеЭлементы.СтраницаКоллизии;
		Элементы.РезультатыОбменаДанными.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоУзлам(УзлыОбмена)
	
	ОтборПоУзламДокумент = ЭлементОтбораДинамическогоСписка(НепроведенныеДокументы,
		НастройкиОтборовДинамическихСписков.НепроведенныеДокументы.УзелВСписке);
	ОтборПоУзламДокумент.Использование = Истина;
	ОтборПоУзламДокумент.ПравоеЗначение = УзлыОбмена;
	
	ОтборПоУзламОбъект = ЭлементОтбораДинамическогоСписка(НезаполненныеРеквизиты,
		НастройкиОтборовДинамическихСписков.НезаполненныеРеквизиты.УзелВСписке);
	ОтборПоУзламОбъект.Использование = Истина;
	ОтборПоУзламОбъект.ПравоеЗначение = УзлыОбмена;
	
	Если ИспользуетсяВерсионирование Тогда
		
		ОтборПоУзламКоллизии = ЭлементОтбораДинамическогоСписка(Коллизии,
			НастройкиОтборовДинамическихСписков.Коллизии.АвторВСписке);
		ОтборПоУзламКоллизии.Использование = Истина;
		ОтборПоУзламКоллизии.ПравоеЗначение = УзлыОбмена;
		
		ОтборПоУзламНепринятые = ЭлементОтбораДинамическогоСписка(НепринятыеПоДате,
			НастройкиОтборовДинамическихСписков.НепринятыеПоДате.АвторВСписке);
		ОтборПоУзламНепринятые.Использование = Истина;
		ОтборПоУзламНепринятые.ПравоеЗначение = УзлыОбмена;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция МассивУзловПриНеконтекстномОткрытии()
	
	УзлыОбмена = Новый Массив;
	
	СписокПлановОбмена = ОбменДаннымиПовтИсп.ПланыОбменаБСП();
	
	Для Каждого ИмяПланаОбмена Из СписокПлановОбмена Цикл
		
		Если Не ПравоДоступа("Чтение", ПланыОбмена[ИмяПланаОбмена].ПустаяСсылка().Метаданные()) Тогда
			Продолжить;
		КонецЕсли;	
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаПланаОбмена.Ссылка КАК УзелОбмена
		|ИЗ
		|	&ТаблицаПланаОбмена КАК ТаблицаПланаОбмена
		|ГДЕ
		|	НЕ ТаблицаПланаОбмена.ЭтотУзел
		|	И ТаблицаПланаОбмена.Ссылка.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Представление";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТаблицаПланаОбмена", "ПланОбмена." + ИмяПланаОбмена);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			УзлыОбмена.Добавить(Выборка.УзелОбмена);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат УзлыОбмена;
	
КонецФункции

&НаСервере
Процедура ОбновитьОтборПоУзлу(Обновлять = Истина)
	
	Использование = ЗначениеЗаполнено(УзелИнформационнойБазы);
	
	ОтборПоУзлуДокумент = ЭлементОтбораДинамическогоСписка(НепроведенныеДокументы,
		НастройкиОтборовДинамическихСписков.НепроведенныеДокументы.УзелРавно);
	ОтборПоУзлуДокумент.Использование = Использование;
	ОтборПоУзлуДокумент.ПравоеЗначение = УзелИнформационнойБазы;
	
	ОтборПоУзлуОбъект = ЭлементОтбораДинамическогоСписка(НезаполненныеРеквизиты,
		НастройкиОтборовДинамическихСписков.НезаполненныеРеквизиты.УзелРавно);
	ОтборПоУзлуОбъект.Использование = Использование;
	ОтборПоУзлуОбъект.ПравоеЗначение = УзелИнформационнойБазы;
	
	Если ИспользуетсяВерсионирование Тогда
		
		ОтборПоУзлуКоллизии = ЭлементОтбораДинамическогоСписка(Коллизии,
			НастройкиОтборовДинамическихСписков.Коллизии.АвторРавно);
		ОтборПоУзлуКоллизии.Использование = Использование;
		ОтборПоУзлуКоллизии.ПравоеЗначение = УзелИнформационнойБазы;
		
		ОтборПоУзлуНепринятые = ЭлементОтбораДинамическогоСписка(НепринятыеПоДате,
			НастройкиОтборовДинамическихСписков.НепринятыеПоДате.АвторРавно);
		ОтборПоУзлуНепринятые.Использование = Использование;
		ОтборПоУзлуНепринятые.ПравоеЗначение = УзелИнформационнойБазы;
		
	КонецЕсли;
	
	Если Обновлять Тогда
		ОбновитьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция КоличествоНепринятых()
	
	УзлыОбмена = ?(ЗначениеЗаполнено(УзелИнформационнойБазы), УзелИнформационнойБазы, СписокУзлов);
	
	Возврат ОбменДаннымиСервер.КоличествоПроблемВерсионирования(УзлыОбмена, Ложь,
		ПоказыватьПроигнорированныеКонфликты, Период, СтрокаПоиска);
	
КонецФункции

&НаСервере
Функция КоличествоКоллизий()
	
	УзлыОбмена = ?(ЗначениеЗаполнено(УзелИнформационнойБазы), УзелИнформационнойБазы, СписокУзлов);
	
	Возврат ОбменДаннымиСервер.КоличествоПроблемВерсионирования(УзлыОбмена, Истина,
		ПоказыватьПроигнорированныеКонфликты, Период, СтрокаПоиска);
	
КонецФункции

&НаСервере
Функция КоличествоНезаполненныхРеквизитов()
	
	УзлыОбмена = ?(ЗначениеЗаполнено(УзелИнформационнойБазы), УзелИнформационнойБазы, СписокУзлов);
	
	Возврат РегистрыСведений.РезультатыОбменаДанными.КоличествоПроблем(УзлыОбмена, Перечисления.ТипыПроблемОбменаДанными.НезаполненныеРеквизиты,
		ПоказыватьПроигнорированныеНезаполненные, Период, СтрокаПоиска);
	
КонецФункции

&НаСервере
Функция КоличествоНепроведенныхДокументов()
	
	УзлыОбмена = ?(ЗначениеЗаполнено(УзелИнформационнойБазы), УзелИнформационнойБазы, СписокУзлов);
	
	Возврат РегистрыСведений.РезультатыОбменаДанными.КоличествоПроблем(УзлыОбмена, Перечисления.ТипыПроблемОбменаДанными.НепроведенныйДокумент,
		ПоказыватьПроигнорированныеНепроведенные, Период, СтрокаПоиска);
	
КонецФункции

&НаСервере
Процедура УстановитьЗаголовокСтраницы(Страница, Заголовок, Количество)
	
	ДобавочнаяСтрока = ?(Количество > 0, " (" + Количество + ")", "");
	Заголовок = Заголовок + ДобавочнаяСтрока;
	Страница.Заголовок = Заголовок;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъект(Элемент)
	
	Если Элемент.ТекущаяСтрока = Неопределено Или ТипЗнч(Элемент.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	Иначе
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеОбъекта()
	
	СтраницыРезультатов = Элементы.РезультатыОбменаДанными;
	
	Если СтраницыРезультатов.ТекущаяСтраница = СтраницыРезультатов.ПодчиненныеЭлементы.СтраницаНепроведенныеДокументы Тогда
		
		ОткрытьОбъект(Элементы.НепроведенныеДокументы); 
		
	ИначеЕсли СтраницыРезультатов.ТекущаяСтраница = СтраницыРезультатов.ПодчиненныеЭлементы.СтраницаНезаполненныеРеквизиты Тогда
		
		ОткрытьОбъект(Элементы.НезаполненныеРеквизиты);
		
	ИначеЕсли СтраницыРезультатов.ТекущаяСтраница = СтраницыРезультатов.ПодчиненныеЭлементы.СтраницаКоллизии Тогда
		
		ОткрытьОбъект(Элементы.Коллизии);
		
	ИначеЕсли СтраницыРезультатов.ТекущаяСтраница = СтраницыРезультатов.ПодчиненныеЭлементы.СтраницаНепринятыеПоДатеЗапрета Тогда
		
		ОткрытьОбъект(Элементы.НепринятыеПоДате);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтличия(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СравниваемыеВерсии = Новый Массив;
	
	Если Элемент.ТекущиеДанные.НомерЭтойВерсии <> 0 Тогда
		СравниваемыеВерсии.Добавить(Элемент.ТекущиеДанные.НомерЭтойВерсии);
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.НомерДругойВерсии <> 0 Тогда
		СравниваемыеВерсии.Добавить(Элемент.ТекущиеДанные.НомерДругойВерсии);
	КонецЕсли;
	
	Если СравниваемыеВерсии.Количество() <> 2 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нет версии для сравнения.'"));
		Возврат;
		
	КонецЕсли;
	
	ОбменДаннымиКлиент.ПриОткрытииФормыОтчетаПоВерсии(Элемент.ТекущиеДанные.Ссылка, СравниваемыеВерсии);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтборПоПричине(Обновлять = Истина)
	
	СтрокаПоискаЗадана = ЗначениеЗаполнено(СтрокаПоиска);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		НепроведенныеДокументы, "Причина", СтрокаПоиска,,, СтрокаПоискаЗадана);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		НезаполненныеРеквизиты, "Причина", СтрокаПоиска,,, СтрокаПоискаЗадана);
		
	Если ИспользуетсяВерсионирование Тогда
	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			НепринятыеПоДате, "ПричинаЗапрета", СтрокаПоиска,,, СтрокаПоискаЗадана);
		
	КонецЕсли;
	
	Если Обновлять Тогда
		
		ОбновитьНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтборПоПериоду(Обновлять = Истина)
	
	Использование = ЗначениеЗаполнено(Период);
	
	// Непроведенные документы
	ОтборПоПериодуДокументС = ЭлементОтбораДинамическогоСписка(НепроведенныеДокументы,
		НастройкиОтборовДинамическихСписков.НепроведенныеДокументы.ДатаНачала);
	ОтборПоПериодуДокументПо = ЭлементОтбораДинамическогоСписка(НепроведенныеДокументы,
		НастройкиОтборовДинамическихСписков.НепроведенныеДокументы.ДатаОкончания);
		
	ОтборПоПериодуДокументС.Использование  = Использование;
	ОтборПоПериодуДокументПо.Использование = Использование;
	
	ОтборПоПериодуДокументС.ПравоеЗначение  = Период.ДатаНачала;
	ОтборПоПериодуДокументПо.ПравоеЗначение = Период.ДатаОкончания;
	
	// Незаполненные реквизиты
	ОтборПоПериодуОбъектС = ЭлементОтбораДинамическогоСписка(НезаполненныеРеквизиты,
		НастройкиОтборовДинамическихСписков.НезаполненныеРеквизиты.ДатаНачала);
	ОтборПоПериодуОбъектПо = ЭлементОтбораДинамическогоСписка(НезаполненныеРеквизиты,
		НастройкиОтборовДинамическихСписков.НезаполненныеРеквизиты.ДатаОкончания);
		
	ОтборПоПериодуОбъектС.Использование  = Использование;
	ОтборПоПериодуОбъектПо.Использование = Использование;
	
	ОтборПоПериодуОбъектС.ПравоеЗначение  = Период.ДатаНачала;
	ОтборПоПериодуОбъектПо.ПравоеЗначение = Период.ДатаОкончания;
	
	Если ИспользуетсяВерсионирование Тогда
		
		ОтборПоПериодуКоллизииС = ЭлементОтбораДинамическогоСписка(Коллизии,
			НастройкиОтборовДинамическихСписков.Коллизии.ДатаНачала);
		ОтборПоПериодуКоллизииПо = ЭлементОтбораДинамическогоСписка(Коллизии,
			НастройкиОтборовДинамическихСписков.Коллизии.ДатаОкончания);
		
		ОтборПоПериодуКоллизииС.Использование  = Использование;
		ОтборПоПериодуКоллизииПо.Использование = Использование;
		
		ОтборПоПериодуКоллизииС.ПравоеЗначение  = Период.ДатаНачала;
		ОтборПоПериодуКоллизииПо.ПравоеЗначение = Период.ДатаОкончания;
		
		ОтборПоПериодуНепринятыеС = ЭлементОтбораДинамическогоСписка(НепринятыеПоДате,
			НастройкиОтборовДинамическихСписков.НепринятыеПоДате.ДатаНачала);
		ОтборПоПериодуНепринятыеПо = ЭлементОтбораДинамическогоСписка(НепринятыеПоДате,
			НастройкиОтборовДинамическихСписков.НепринятыеПоДате.ДатаОкончания);
		
		ОтборПоПериодуНепринятыеС.Использование  = Использование;
		ОтборПоПериодуНепринятыеПо.Использование = Использование;
		
		ОтборПоПериодуНепринятыеС.ПравоеЗначение  = Период.ДатаНачала;
		ОтборПоПериодуНепринятыеПо.ПравоеЗначение = Период.ДатаОкончания;
		
	КонецЕсли;
	
	Если Обновлять Тогда
		ОбновитьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ИгнорироватьВерсию(Знач ВыделенныеСтроки, Игнорировать, ИмяЭлемента)
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ОбменДаннымиСервер.ПриИгнорированииВерсииОбъекта(ВыделеннаяСтрока.Объект, ВыделеннаяСтрока.НомерВерсии, Игнорировать);
		
	КонецЦикла;
	
	ОбновитьНаСервере(ИмяЭлемента);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере(ОбновляемыйЭлемент = "")
	
	ОбновитьСпискиФормы(ОбновляемыйЭлемент);
	ОбновитьЗаголовкиСтраниц();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСпискиФормы(ОбновляемыйЭлемент)
	
	Если ЗначениеЗаполнено(ОбновляемыйЭлемент) Тогда
		
		Элементы[ОбновляемыйЭлемент].Обновить();
		
	Иначе
		
		Элементы.НепроведенныеДокументы.Обновить();
		Элементы.НезаполненныеРеквизиты.Обновить();
		Если ИспользуетсяВерсионирование Тогда
			Элементы.Коллизии.Обновить();
			Элементы.НепринятыеПоДате.Обновить();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовкиСтраниц()
	
	УстановитьЗаголовокСтраницы(Элементы.СтраницаНепроведенныеДокументы, НСтр("ru= 'Непроведенные документы'"), КоличествоНепроведенныхДокументов());
	УстановитьЗаголовокСтраницы(Элементы.СтраницаНезаполненныеРеквизиты, НСтр("ru= 'Незаполненные реквизиты'"), КоличествоНезаполненныхРеквизитов());
	
	Если ИспользуетсяВерсионирование Тогда
		УстановитьЗаголовокСтраницы(Элементы.СтраницаКоллизии, НСтр("ru= 'Конфликты'"), КоличествоКоллизий());
		УстановитьЗаголовокСтраницы(Элементы.СтраницаНепринятыеПоДатеЗапрета, НСтр("ru= 'Непринятые по дате запрета'"), КоличествоНепринятых());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюНаКлиенте(ТекущиеДанные, Версия)
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СравниваемыеВерсии = Новый Массив;
	СравниваемыеВерсии.Добавить(Версия);
	ОбменДаннымиКлиент.ПриОткрытииФормыОтчетаПоВерсии(ТекущиеДанные.Ссылка, СравниваемыеВерсии);
	
КонецПроцедуры

&НаСервере
Процедура ПринятьОтклонитьВерсиюНаСервере(Знач ВыделенныеСтроки, ИмяЭлемента)
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ОбменДаннымиСервер.ПриПереходеНаВерсиюОбъекта(ВыделеннаяСтрока.Объект, ВыделеннаяСтрока.НомерВерсии);
		
	КонецЦикла;
	
	ОбновитьНаСервере(ИмяЭлемента);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтборыДинамическихСписков(Результат)
	
	Результат = Новый Структура;
	
	// Непроведенные документы
	Отбор = НепроведенныеДокументы.КомпоновщикНастроек.Настройки.Отбор;
	Результат.Вставить("НепроведенныеДокументы", Новый Структура);
	Настройка = Результат.НепроведенныеДокументы;
	
	Настройка.Вставить("Пропущена", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Пропущена", ВидСравненияКомпоновкиДанных.Равно, Ложь, ,Истина)));
	Настройка.Вставить("ДатаНачала", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ДатаВозникновения", ВидСравненияКомпоновкиДанных.БольшеИлиРавно, '00010101', , Истина)));
	Настройка.Вставить("ДатаОкончания", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ДатаВозникновения", ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, '00010101', , Истина)));
	Настройка.Вставить("УзелРавно", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "УзелИнформационнойБазы", ВидСравненияКомпоновкиДанных.Равно, Неопределено, , Ложь)));
	Настройка.Вставить("Причина", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Причина", ВидСравненияКомпоновкиДанных.Содержит, Неопределено, , Ложь)));
	Настройка.Вставить("УзелВСписке", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "УзелИнформационнойБазы", ВидСравненияКомпоновкиДанных.ВСписке, Неопределено, , Ложь)));
		
	// Незаполненные реквизиты
	Отбор = НезаполненныеРеквизиты.КомпоновщикНастроек.Настройки.Отбор;
	Результат.Вставить("НезаполненныеРеквизиты", Новый Структура);
	Настройка = Результат.НезаполненныеРеквизиты;
	
	Настройка.Вставить("Пропущена", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Пропущена", ВидСравненияКомпоновкиДанных.Равно, Ложь, ,Истина)));
	Настройка.Вставить("ДатаНачала", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ДатаВозникновения", ВидСравненияКомпоновкиДанных.БольшеИлиРавно, '00010101', , Истина)));
	Настройка.Вставить("ДатаОкончания", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ДатаВозникновения", ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, '00010101', , Истина)));
	Настройка.Вставить("УзелРавно", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "УзелИнформационнойБазы", ВидСравненияКомпоновкиДанных.Равно, Неопределено, , Ложь)));
	Настройка.Вставить("Причина", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Причина", ВидСравненияКомпоновкиДанных.Содержит, Неопределено, , Ложь)));
	Настройка.Вставить("УзелВСписке", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "УзелИнформационнойБазы", ВидСравненияКомпоновкиДанных.ВСписке, Неопределено, , Ложь)));
		
	Если ИспользуетсяВерсионирование Тогда
		
		// Конфликты
		Отбор = Коллизии.КомпоновщикНастроек.Настройки.Отбор;
		Результат.Вставить("Коллизии", Новый Структура);
		Настройка = Результат.Коллизии;
		
		Настройка.Вставить("АвторРавно", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "АвторДругойВерсии", ВидСравненияКомпоновкиДанных.Равно, Неопределено, ,Ложь)));
		Настройка.Вставить("ДатаНачала", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Дата", ВидСравненияКомпоновкиДанных.БольшеИлиРавно, '00010101', , Истина)));
		Настройка.Вставить("ДатаОкончания", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Дата", ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, '00010101', , Истина)));
		Настройка.Вставить("ВерсияПроигнорирована", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ВерсияПроигнорирована", ВидСравненияКомпоновкиДанных.Равно, Ложь, , Истина)));
		Настройка.Вставить("АвторВСписке", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "АвторДругойВерсии", ВидСравненияКомпоновкиДанных.ВСписке, Неопределено, ,Ложь)));
		
		// Непринятые по дате запрета
		Отбор = НепринятыеПоДате.КомпоновщикНастроек.Настройки.Отбор;
		Результат.Вставить("НепринятыеПоДате", Новый Структура);
		Настройка = Результат.НепринятыеПоДате;
		
		Настройка.Вставить("АвторРавно", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "АвторДругойВерсии", ВидСравненияКомпоновкиДанных.Равно, Неопределено, ,Ложь)));
		Настройка.Вставить("ДатаНачала", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Дата", ВидСравненияКомпоновкиДанных.БольшеИлиРавно, '00010101', , Истина)));
		Настройка.Вставить("ДатаОкончания", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Дата", ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, '00010101', , Истина)));
		Настройка.Вставить("ПричинаЗапрета", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ПричинаЗапрета", ВидСравненияКомпоновкиДанных.Равно, Неопределено, , Ложь)));
		Настройка.Вставить("ВерсияПроигнорирована", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ВерсияПроигнорирована", ВидСравненияКомпоновкиДанных.Равно, Ложь, , Истина)));
		Настройка.Вставить("АвторВСписке", Отбор.ПолучитьИдентификаторПоОбъекту(
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "АвторДругойВерсии", ВидСравненияКомпоновкиДанных.ВСписке, Неопределено, ,Ложь)));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭлементОтбораДинамическогоСписка(Знач ДинамическийСписок, Знач Идентификатор)
	Возврат ДинамическийСписок.КомпоновщикНастроек.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(Идентификатор);
КонецФункции

&НаСервере
Процедура ОбновитьОтборыИПроигнорированные()
	
	ОбновитьОтборПоПериоду(Ложь);
	ОбновитьОтборПоУзлу(Ложь);
	ОбновитьОтборПоПричине(Ложь);
	
	ПоказыватьПроигнорированныеНепроведенныеНаСервере(Ложь);
	ПоказыватьПроигнорированныеНезаполненныеНаСервере(Ложь);
	
	Если ИспользуетсяВерсионирование Тогда
		
		ПоказыватьПроигнорированныеКонфликтыНаСервере(Ложь);
		ПоказыватьПроигнорированныеНепринятыеНаСервере(Ложь);
		
	КонецЕсли;
	
	ОбновитьНаСервере();
	
	Если Не Элементы.РезультатыОбменаДанными.ТекущаяСтраница = Элементы.РезультатыОбменаДанными.ПодчиненныеЭлементы.СтраницаКоллизии Тогда
		
		Для Каждого Страница Из Элементы.РезультатыОбменаДанными.ПодчиненныеЭлементы Цикл
			
			Если СтрНайти(Страница.Заголовок, "(") Тогда
				Элементы.РезультатыОбменаДанными.ТекущаяСтраница = Страница;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	НепроведенныеДокументы.УсловноеОформление.Элементы.Очистить();
	Элемент = НепроведенныеДокументы.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Пропущена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

#КонецОбласти
