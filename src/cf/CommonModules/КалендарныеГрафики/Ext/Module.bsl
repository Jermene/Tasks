﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Календарные графики".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает массив дат, которые отличается указанной даты на количество дней,
// входящих в указанный график.
//
// Параметры:
//	ГрафикРаботы	- график (или производственный календарь), который необходимо использовать, 
//		тип СправочникСсылка.Календари или СправочникСсылка.ПроизводственныеКалендари.
//	ДатаОт			- дата, от которой нужно рассчитать количество дней, тип Дата.
//	МассивДней		- массив с количеством дней, на которые нужно увеличить дату начала, тип Массив,Число.
//	РассчитыватьСледующуюДатуОтПредыдущей	- нужно ли рассчитывать следующую дату от предыдущей или
//											  все даты рассчитываются от переданной даты.
//	ВызыватьИсключение - булево, если Истина вызывается исключение в случае незаполненного графика.
//
// Возвращаемое значение
//	Массив		- массив дат, увеличенных на количество дней, входящих в график,
//	Если выбранный график не заполнен, и ВызыватьИсключение = Ложь, возвращается Неопределено.
//
Функция ПолучитьМассивДатПоКалендарю(Знач ГрафикРаботы, Знач ДатаОт, Знач МассивДней, Знач РассчитыватьСледующуюДатуОтПредыдущей = Ложь, ВызыватьИсключение = Истина) Экспорт
	
	Если Не ЗначениеЗаполнено(ГрафикРаботы) Тогда
		Если ВызыватьИсключение Тогда
			ВызватьИсключение НСтр("ru = 'Не указан график работы или производственный календарь.'");
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(ГрафикРаботы) <> Тип("СправочникСсылка.ПроизводственныеКалендари") Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрафикиРаботы") Тогда
			МодульГрафикиРаботы = ОбщегоНазначения.ОбщийМодуль("ГрафикиРаботы");
			Возврат МодульГрафикиРаботы.ДатыПоГрафику(
				ГрафикРаботы, ДатаОт, МассивДней, РассчитыватьСледующуюДатуОтПредыдущей, ВызыватьИсключение);
		КонецЕсли;
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТПриращениеДней(МенеджерВременныхТаблиц, МассивДней, РассчитыватьСледующуюДатуОтПредыдущей);
	
	// Алгоритм работает следующим образом:
	// Получаем все дни календаря, следующие после даты отсчета.
	// Для каждого из таких дней рассчитываем количество дней, включенных в график с даты отсчета.
	// Отбираем рассчитанное таким образом количество по таблице приращения дней.
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	// По производственному календарю.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КалендарныеГрафики.Дата КАК ДатаГрафика
	|ПОМЕСТИТЬ ВТПоследующиеДатыГрафика
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Дата >= &ДатаОт
	|	И КалендарныеГрафики.ПроизводственныйКалендарь = &ГрафикРаботы
	|	И КалендарныеГрафики.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследующиеДатыГрафика.ДатаГрафика,
	|	КОЛИЧЕСТВО(КалендарныеГрафики.ДатаГрафика) - 1 КАК КоличествоДнейВключенныхВГрафик
	|ПОМЕСТИТЬ ВТПоследующиеДатыГрафикаСКоличествомДней
	|ИЗ
	|	ВТПоследующиеДатыГрафика КАК ПоследующиеДатыГрафика
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПоследующиеДатыГрафика КАК КалендарныеГрафики
	|		ПО (КалендарныеГрафики.ДатаГрафика <= ПоследующиеДатыГрафика.ДатаГрафика)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоследующиеДатыГрафика.ДатаГрафика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПриращениеДней.ИндексСтроки,
	|	ЕСТЬNULL(ПоследующиеДни.ДатаГрафика, НЕОПРЕДЕЛЕНО) КАК ДатаПоКалендарю
	|ИЗ
	|	ВТПриращениеДней КАК ПриращениеДней
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоследующиеДатыГрафикаСКоличествомДней КАК ПоследующиеДни
	|		ПО ПриращениеДней.КоличествоДней = ПоследующиеДни.КоличествоДнейВключенныхВГрафик
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПриращениеДней.ИндексСтроки";
	
	Запрос.УстановитьПараметр("ДатаОт", НачалоДня(ДатаОт));
	Запрос.УстановитьПараметр("ГрафикРаботы", ГрафикРаботы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивДат = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ДатаПоКалендарю = Неопределено Тогда
			СообщениеОбОшибке = НСтр("ru = 'Производственный календарь «%1» не заполнен с даты %2 на указанное количество рабочих дней.'");
			Если ВызыватьИсключение Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ГрафикРаботы, Формат(ДатаОт, "ДЛФ=D"));
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		МассивДат.Добавить(Выборка.ДатаПоКалендарю);
	КонецЦикла;
	
	Возврат МассивДат;
	
КонецФункции

// Функция возвращает дату, которая отличается указанной даты на количество дней,
// входящих в указанный график.
//
// Параметры:
//	ГрафикРаботы	- график (или производственный календарь), который необходимо использовать, 
//		тип СправочникСсылка.Календари или СправочникСсылка.ПроизводственныеКалендари.
//	ДатаОт			- дата, от которой нужно рассчитать количество дней, тип Дата.
//	КоличествоДней	- количество дней, на которые нужно увеличить дату начала, тип Число.
//	ВызыватьИсключение - булево, если Истина вызывается исключение в случае незаполненного графика.
//
// Возвращаемое значение
//	Дата			- дата, увеличенная на количество дней, входящих в график.
//	Если выбранный график не заполнен, и ВызыватьИсключение = Ложь, возвращается Неопределено.
//
Функция ПолучитьДатуПоКалендарю(Знач ГрафикРаботы, Знач ДатаОт, Знач КоличествоДней, ВызыватьИсключение = Истина) Экспорт
	
	Если Не ЗначениеЗаполнено(ГрафикРаботы) Тогда
		Если ВызыватьИсключение Тогда
			ВызватьИсключение НСтр("ru = 'Не указан график работы или производственный календарь.'");
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	ДатаОт = НачалоДня(ДатаОт);
	
	Если КоличествоДней = 0 Тогда
		Возврат ДатаОт;
	КонецЕсли;
	
	МассивДней = Новый Массив;
	МассивДней.Добавить(КоличествоДней);
	
	МассивДат = ПолучитьМассивДатПоКалендарю(ГрафикРаботы, ДатаОт, МассивДней, , ВызыватьИсключение);
	
	Возврат ?(МассивДат <> Неопределено, МассивДат[0], Неопределено);
	
КонецФункции

// Функция определяет количество дней, входящих в график, для указанного периода.
//
// Параметры:
//	ГрафикРаботы	- график (или производственный календарь), который необходимо использовать, 
//		тип СправочникСсылка.Календари или СправочникСсылка.ПроизводственныеКалендари.
//	ДатаНачала		- дата начала периода.
//	ДатаОкончания	- дата окончания периода.
//	ВызыватьИсключение - булево, если Истина вызывается исключение в случае незаполненного графика.
//
// Возвращаемое значение
//	Число		- количество дней между датами начала и окончания.
//	Если выбранный график не заполнен, и ВызыватьИсключение = Ложь, возвращается Неопределено.
//
Функция ПолучитьРазностьДатПоКалендарю(Знач ГрафикРаботы, Знач ДатаНачала, Знач ДатаОкончания, ВызыватьИсключение = Истина) Экспорт
	
	Если Не ЗначениеЗаполнено(ГрафикРаботы) Тогда
		Если ВызыватьИсключение Тогда
			ВызватьИсключение НСтр("ru = 'Не указан график работы или производственный календарь.'");
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	ДатаНачала = НачалоДня(ДатаНачала);
	ДатаОкончания = НачалоДня(ДатаОкончания);
	
	ДатыГрафика = Новый Массив;
	ДатыГрафика.Добавить(ДатаНачала);
	Если Год(ДатаНачала) <> Год(ДатаОкончания) И КонецДня(ДатаНачала) <> КонецГода(ДатаНачала) Тогда
		// Если даты разных годов, то добавляем «границы» годов.
		Для НомерГода = Год(ДатаНачала) По Год(ДатаОкончания) - 1 Цикл
			ДатыГрафика.Добавить(Дата(НомерГода, 12, 31));
		КонецЦикла;
	КонецЕсли;
	ДатыГрафика.Добавить(ДатаОкончания);
	
	// Формируем текст запроса временной таблицы, содержащей указанные даты.
	ТекстЗапроса = "";
	Для Каждого ДатаГрафика Из ДатыГрафика Цикл
		Если ПустаяСтрока(ТекстЗапроса) Тогда
			ШаблонОбъединения = 
			"ВЫБРАТЬ
			|	ДАТАВРЕМЯ(%1) КАК ДатаГрафика
			|ПОМЕСТИТЬ ВТДатыГрафика
			|";
		Иначе
			ШаблонОбъединения = 
			"ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ДАТАВРЕМЯ(%1)";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОбъединения, Формат(ДатаГрафика, "ДФ='гггг, ММ, д'"));
	КонецЦикла;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	// Готовим временные таблицы с исходными данными.
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДатыГрафика.ДатаГрафика
	|ПОМЕСТИТЬ ВТРазличныеДатыГрафика
	|ИЗ
	|	ВТДатыГрафика КАК ДатыГрафика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГОД(ДатыГрафика.ДатаГрафика) КАК Год
	|ПОМЕСТИТЬ ВТРазличныеГодыГрафика
	|ИЗ
	|	ВТДатыГрафика КАК ДатыГрафика";
	
	Запрос.Выполнить();
	
	Если ТипЗнч(ГрафикРаботы) = Тип("СправочникСсылка.ПроизводственныеКалендари") Тогда
		// По производственному календарю.
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	КалендарныеГрафики.Год,
		|	КалендарныеГрафики.Дата КАК ДатаГрафика,
		|	ВЫБОР
		|		КОГДА КалендарныеГрафики.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ДеньВключенВГрафик
		|ПОМЕСТИТЬ ВТКалендарныеГрафики
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК КалендарныеГрафики
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРазличныеГодыГрафика КАК ГодыГрафика
		|		ПО (ГодыГрафика.Год = КалендарныеГрафики.Год)
		|ГДЕ
		|	КалендарныеГрафики.ПроизводственныйКалендарь = &ГрафикРаботы";
		Запрос.УстановитьПараметр("ГрафикРаботы", ГрафикРаботы);
		Запрос.Выполнить();
	Иначе
		// По графику работы
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрафикиРаботы") Тогда
			МодульГрафикиРаботы = ОбщегоНазначения.ОбщийМодуль("ГрафикиРаботы");
			МодульГрафикиРаботы.СоздатьВТДанныеГрафика(МенеджерВременныхТаблиц, ГрафикРаботы);
		КонецЕсли;
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДатыГрафика.ДатаГрафика,
	|	КОЛИЧЕСТВО(ДниВключенныеВГрафик.ДатаГрафика) КАК КоличествоДнейВГрафикеСНачалаГода
	|ПОМЕСТИТЬ ВТКоличествоДнейВключенныхВГрафик
	|ИЗ
	|	ВТРазличныеДатыГрафика КАК ДатыГрафика
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКалендарныеГрафики КАК ДниВключенныеВГрафик
	|		ПО (ДниВключенныеВГрафик.Год = ГОД(ДатыГрафика.ДатаГрафика))
	|			И (ДниВключенныеВГрафик.ДатаГрафика <= ДатыГрафика.ДатаГрафика)
	|			И (ДниВключенныеВГрафик.ДеньВключенВГрафик)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДатыГрафика.ДатаГрафика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДатыГрафика.ДатаГрафика,
	|	ЕСТЬNULL(ДанныеГрафика.ДеньВключенВГрафик, ЛОЖЬ) КАК ДеньВключенВГрафик,
	|	ДниВключенныеВГрафик.КоличествоДнейВГрафикеСНачалаГода
	|ИЗ
	|	ВТДатыГрафика КАК ДатыГрафика
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКалендарныеГрафики КАК ДанныеГрафика
	|		ПО (ДанныеГрафика.Год = ГОД(ДатыГрафика.ДатаГрафика))
	|			И (ДанныеГрафика.ДатаГрафика = ДатыГрафика.ДатаГрафика)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКоличествоДнейВключенныхВГрафик КАК ДниВключенныеВГрафик
	|		ПО (ДниВключенныеВГрафик.ДатаГрафика = ДатыГрафика.ДатаГрафика)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатыГрафика.ДатаГрафика";
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Если ВызыватьИсключение Тогда
			СообщениеОбОшибке = НСтр("ru = 'График работы «%1» не заполнен на период %2.'");
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ГрафикРаботы, ПредставлениеПериода(ДатаНачала, КонецДня(ДатаОкончания)));
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	// Получаем выборку, в которой для каждой исходной даты определено количество дней, 
	// включенных в график с начала года.
	// Из значения, заданного на первую дату выборки вычитаем все последующие, 
	// получая таким образом количество дней, включенных в график за весь период со знаком минус.
	// Если первый день выборки является рабочим, а последующий - выходным, 
	// то количество дней включенных на обе эти даты будет одинаковым, 
	// в этом случае для корректировки добавляем к итоговому значению 1 день.
	
	КоличествоДнейВГрафике = Неопределено;
	ДобавлятьПервыйДень = Ложь;
	
	Пока Выборка.Следующий() Цикл
		Если КоличествоДнейВГрафике = Неопределено Тогда
			КоличествоДнейВГрафике = Выборка.КоличествоДнейВГрафикеСНачалаГода;
			ДобавлятьПервыйДень = Выборка.ДеньВключенВГрафик;
		Иначе
			КоличествоДнейВГрафике = КоличествоДнейВГрафике - Выборка.КоличествоДнейВГрафикеСНачалаГода;
		КонецЕсли;
	КонецЦикла;
	
	Возврат - КоличествоДнейВГрафике + ?(ДобавлятьПервыйДень, 1, 0);
	
КонецФункции

// Функция определяет для каждой даты дату ближайшего к ней рабочего дня.
//
//	Параметры:
//	График 						- ссылка на график работы или производственный календарь.
//	НачальныеДаты 				- массив дат.
//	ПолучатьПредшествующие		- способ получения ближайшей даты, 
//								если Истина - определяются рабочие даты, предшествующие переданным в параметре НачальныеДаты, 
//								если Ложь - получаются даты не ранее начальной даты.
//	ВызыватьИсключение 			- булево, если Истина вызывается исключение в случае незаполненного графика.
//	ИгнорироватьНезаполненностьГрафика - булево, если Истина, то в любом случае будет возвращено соответствие. 
//								Начальные даты, для которых не будет значений из-за незаполненности графика, включены не будут.
//
//	Возвращаемое значение:
//	РабочиеДаты					- соответствие, где ключ - дата из переданного массива, 
//								значение - ближайшая к ней рабочая дата (если передана рабочая дата, то она же и возвращается).
//	Если выбранный график не заполнен, и ВызыватьИсключение = Ложь, возвращается Неопределено.
//
Функция ПолучитьДатыРабочихДней(График, НачальныеДаты, ПолучатьПредшествующие = Ложь, ВызыватьИсключение = Истина, ИгнорироватьНезаполненностьГрафика = Ложь) Экспорт
	
	Если Не ЗначениеЗаполнено(График) Тогда
		Если ВызыватьИсключение Тогда
			ВызватьИсключение НСтр("ru = 'Не указан график работы или производственный календарь.'");
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстЗапросаВТ = "";
	ПерваяЧасть = Истина;
	Для Каждого НачальнаяДата Из НачальныеДаты Цикл
		Если Не ЗначениеЗаполнено(НачальнаяДата) Тогда
			Продолжить;
		КонецЕсли;
		Если Не ПерваяЧасть Тогда
			ТекстЗапросаВТ = ТекстЗапросаВТ + "
			|ОБЪЕДИНИТЬ ВСЕ
			|";
		КонецЕсли;
		ТекстЗапросаВТ = ТекстЗапросаВТ + "
		|ВЫБРАТЬ
		|	ДАТАВРЕМЯ(" + Формат(НачальнаяДата, "ДФ=гггг,ММ,дд") + ")";
		Если ПерваяЧасть Тогда
			ТекстЗапросаВТ = ТекстЗапросаВТ + " КАК Дата 
			|ПОМЕСТИТЬ НачальныеДаты
			|";
		КонецЕсли;
		ПерваяЧасть = Ложь;
	КонецЦикла;

	Если ПустаяСтрока(ТекстЗапросаВТ) Тогда
		Возврат Новый Соответствие;
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапросаВТ);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	Если ТипЗнч(График) = Тип("СправочникСсылка.ПроизводственныеКалендари") Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	НачальныеДаты.Дата,
		|	%Функция%(ДатыКалендаря.Дата) КАК БлижайшаяДата
		|ИЗ
		|	НачальныеДаты КАК НачальныеДаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДатыКалендаря
		|		ПО (ДатыКалендаря.Дата %ЗнакУсловия% НачальныеДаты.Дата)
		|			И (ДатыКалендаря.ПроизводственныйКалендарь = &График)
		|			И (ДатыКалендаря.ВидДня В (
		|			ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), 
		|			ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)
		|			))
		|
		|СГРУППИРОВАТЬ ПО
		|	НачальныеДаты.Дата";
	Иначе
		// По графику работы
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрафикиРаботы") Тогда
			МодульГрафикиРаботы = ОбщегоНазначения.ОбщийМодуль("ГрафикиРаботы");
			ТекстЗапроса = МодульГрафикиРаботы.ШаблонТекстаЗапросаОпределенияБлижайшихДатПоГрафикуРаботы();
		КонецЕсли;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Функция%", 				?(ПолучатьПредшествующие, "МАКСИМУМ", "МИНИМУМ"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ЗнакУсловия%", 			?(ПолучатьПредшествующие, "<=", ">="));
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("График", График);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДатыРабочихДней = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.БлижайшаяДата) Тогда
			ДатыРабочихДней.Вставить(Выборка.Дата, Выборка.БлижайшаяДата);
		Иначе 
			Если ИгнорироватьНезаполненностьГрафика Тогда
				Продолжить;
			КонецЕсли;
			Если ВызыватьИсключение Тогда
				ТекстСообщения = НСтр("ru = 'Невозможно определить ближайшую рабочую дату для даты %1, возможно, график работы не заполнен.'");
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(Выборка.Дата, "ДЛФ=D"));
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДатыРабочихДней;
	
КонецФункции

// Составляет расписания работы для дат, включенных в указанные графики на указанный период.
// Если расписание на предпраздничный день не задано, то оно определяется так, как если бы этот день был бы рабочим.
//
// ВНИМАНИЕ! Для работы метода обязательно наличие подсистемы ГрафикиРаботы.
//
// Параметры:
//	Графики - массив элементов типа СправочникСсылка.Календари.
//	ДатаНачала - дата начала периода, за который нужно составить расписания.
//	ДатаОкончания - дата окончания периода.
//
// Возвращаемое значение - таблица значений с колонками.
//	ГрафикРаботы
//	ДатаГрафика
//	ВремяНачала
//	ВремяОкончания
//
Функция РасписанияРаботыНаПериод(Графики, ДатаНачала, ДатаОкончания) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрафикиРаботы") Тогда
		МодульГрафикиРаботы = ОбщегоНазначения.ОбщийМодуль("ГрафикиРаботы");
		Возврат МодульГрафикиРаботы.РасписанияРаботыНаПериод(Графики, ДатаНачала, ДатаОкончания);
	КонецЕсли;
	
	ВызватьИсключение НСтр("ru = 'Подсистема «Графики работы» не обнаружена.'");
	
КонецФункции

// Создает в менеджере временную таблицу ВТРасписанияРаботы с колонками.
// Подробнее см. комментарий к функции РасписанияРаботыНаПериод.
//
// ВНИМАНИЕ! Для работы метода обязательно наличие подсистемы ГрафикиРаботы.
//
Процедура СоздатьВТРасписанияРаботыНаПериод(МенеджерВременныхТаблиц, Графики, ДатаНачала, ДатаОкончания) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрафикиРаботы") Тогда
		МодульГрафикиРаботы = ОбщегоНазначения.ОбщийМодуль("ГрафикиРаботы");
		МодульГрафикиРаботы.СоздатьВТРасписанияРаботыНаПериод(МенеджерВременныхТаблиц, Графики, ДатаНачала, ДатаОкончания);
		Возврат;
	КонецЕсли;
	
	ВызватьИсключение НСтр("ru = 'Подсистема «Графики работы» не обнаружена.'");
	
КонецПроцедуры

// Заполняет реквизит в форме, в том случае, если в используется единственный производственный календарь.
//
// Параметры:
//	Форма
//	ПутьРеквизита - строка, путь к данным, например: "Объект.ПроизводственныйКалендарь".
//
Процедура ЗаполнитьПроизводственныйКалендарьВФорме(Форма, ПутьРеквизита) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоПроизводственныхКалендарей") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользуемыеКалендари = Справочники.ПроизводственныеКалендари.СписокПроизводственныхКалендарей();
	
	Если ИспользуемыеКалендари.Количество() > 0 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ПутьРеквизита, ИспользуемыеКалендари[0]);
	КонецЕсли;
	
КонецПроцедуры

// Позволяет получить производственный календарь, 
// составленный в соответствии с ст. 112 ТК РФ.
//
// Возвращаемое значение - ссылка на элемент справочника Производственные календари, 
//		Неопределено, в случае если производственный календарь не обнаружен.
//
Функция ПроизводственныйКалендарьРоссийскойФедерации() Экспорт
		
	ПроизводственныйКалендарь = Справочники.ПроизводственныеКалендари.НайтиПоКоду("РФ");
	
	Если ПроизводственныйКалендарь.Пустая() Тогда 
		Возврат Неопределено;
	КонецЕсли;

	Возврат ПроизводственныйКалендарь;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Объявляет служебные события подсистемы КалендарныеГрафики:
//
// Серверные события:
//   ПриОбновленииПроизводственныхКалендарей.
//
// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия) Экспорт
	
	// СЕРВЕРНЫЕ СОБЫТИЯ.
	
	// Вызывается при изменении данных производственных календарей.
	//
	// Параметры:
	//	- УсловияОбновления - таблица значений с колонками.
	//		- КодПроизводственногоКалендаря - код производственного календаря, данные которого изменились,
	//		- Год - год, за который изменились данные.
	//
	// Синтаксис:
	// Процедура ПриОбновленииПроизводственныхКалендарей(УсловияОбновления) Экспорт
	//
	// (То же, что КалендарныеГрафикиПереопределяемый.ПриОбновленииПроизводственныхКалендарей).
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.КалендарныеГрафики\ПриОбновленииПроизводственныхКалендарей");
	
КонецПроцедуры

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"
	].Добавить("КалендарныеГрафики");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ВыгрузкаЗагрузкаДанных") Тогда
		СерверныеОбработчики[
			"ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке"
		].Добавить("КалендарныеГрафики");
	КонецЕсли;
	
КонецПроцедуры

// Создает временную таблицу ВТПриращениеДней, в которой для каждого элемента из МассивДней 
// формируется строка с индексом элемента и значением - количеством дней.
// 
// Параметры:
//	- МенеджерВременныхТаблиц,
//	- МассивДней - массив, количество дней,
//	- РассчитыватьСледующуюДатуОтПредыдущей - необязательный, по умолчанию Ложь.
//
Процедура СоздатьВТПриращениеДней(МенеджерВременныхТаблиц, Знач МассивДней, Знач РассчитыватьСледующуюДатуОтПредыдущей = Ложь) Экспорт
	
	ПриращениеДней = Новый ТаблицаЗначений;
	ПриращениеДней.Колонки.Добавить("ИндексСтроки", Новый ОписаниеТипов("Число"));
	ПриращениеДней.Колонки.Добавить("КоличествоДней", Новый ОписаниеТипов("Число"));
	
	КоличествоДней = 0;
	НомерСтроки = 0;
	Для Каждого СтрокаДней Из МассивДней Цикл
		КоличествоДней = КоличествоДней + СтрокаДней;
		
		Строка = ПриращениеДней.Добавить();
		Строка.ИндексСтроки			= НомерСтроки;
		Если РассчитыватьСледующуюДатуОтПредыдущей Тогда
			Строка.КоличествоДней	= КоличествоДней;
		Иначе
			Строка.КоличествоДней	= СтрокаДней;
		КонецЕсли;
			
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПриращениеДней.ИндексСтроки,
	|	ПриращениеДней.КоличествоДней
	|ПОМЕСТИТЬ ВТПриращениеДней
	|ИЗ
	|	&ПриращениеДней КАК ПриращениеДней";
	
	Запрос.УстановитьПараметр("ПриращениеДней",	ПриращениеДней);
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Обновляет справочник Производственные календари из одноименного макета.
//
Процедура ОбновитьПроизводственныеКалендари() Экспорт
	
	ТекстовыйДокумент = Справочники.ПроизводственныеКалендари.ПолучитьМакет("ОписаниеКалендарей");
	ТаблицаКалендарей = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстовыйДокумент.ПолучитьТекст()).Данные;
	
	Справочники.ПроизводственныеКалендари.ОбновитьПроизводственныеКалендари(ТаблицаКалендарей);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в эту подсистему.

// См. одноименную процедуру в общем модуле ПользователиПереопределяемый.
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	// ТолькоДляПользователейСистемы.
	НазначениеРолей.ТолькоДляПользователейСистемы.Добавить(
		Метаданные.Роли.ДобавлениеИзменениеКалендарныхГрафиков.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет массив типов неразделенных данных, для которых поддерживается сопоставление ссылок
// при загрузке данных в другую информационную базу.
//
// Параметры:
//  Типы - Массив(ОбъектМетаданных).
//
Процедура ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы) Экспорт
	
	Типы.Добавить(Метаданные.Справочники.ПроизводственныеКалендари);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "КалендарныеГрафики.ОбновитьПроизводственныеКалендари";
	Обработчик.Версия = "1.0.0.1";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "КалендарныеГрафики.ОбновитьДанныеПроизводственныхКалендарей";
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.Версия = "1.0.0.1";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "КалендарныеГрафики.ОбновитьИспользованиеНесколькихПроизводственныхКалендарей";
	Обработчик.Версия = "1.0.0.1";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.3.7";
	Обработчик.Процедура = "КалендарныеГрафики.ОбновитьИспользованиеНесколькихПроизводственныхКалендарей";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.3.1.2";
	Обработчик.Процедура = "КалендарныеГрафики.УдалитьОшибочныеДанныеПроизводственногоКалендаря";
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.3.2.75";
	Обработчик.Процедура = "КалендарныеГрафики.ОбновитьДанныеПроизводственныхКалендарей";
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры

// Обновляет данные производственных календарей из макета.
//  ДанныеПроизводственныхКалендарей.
//
Процедура ОбновитьДанныеПроизводственныхКалендарей() Экспорт
	
	ТаблицаДанных = Справочники.ПроизводственныеКалендари.ДанныеПроизводственныхКалендарейИзМакета();
	
	// Обновляем данные производственных календарей.
	Справочники.ПроизводственныеКалендари.ОбновитьДанныеПроизводственныхКалендарей(ТаблицаДанных);
	
КонецПроцедуры

// Устанавливает значение константы, определяющей использование нескольких производственных календарей.
//
Процедура ОбновитьИспользованиеНесколькихПроизводственныхКалендарей() Экспорт
	
	ИспользоватьНесколькоКалендарей = Справочники.ПроизводственныеКалендари.СписокПроизводственныхКалендарей().Количество() <> 1;
	Если ИспользоватьНесколькоКалендарей <> ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоПроизводственныхКалендарей") Тогда
		Константы.ИспользоватьНесколькоПроизводственныхКалендарей.Установить(ИспользоватьНесколькоКалендарей);
	КонецЕсли;
	
КонецПроцедуры

// Удаляет ошибочно добавленные записи регистра сведений с упоминанием дат, не относящихся к данным годов.
//
Процедура УдалитьОшибочныеДанныеПроизводственногоКалендаря() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь,
		|	ДанныеПроизводственногоКалендаря.Год
		|ПОМЕСТИТЬ ВТОшибочныеДанные
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|ГДЕ
		|	ДанныеПроизводственногоКалендаря.Год <> ГОД(ДанныеПроизводственногоКалендаря.Дата)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеКалендаря.ПроизводственныйКалендарь,
		|	ДанныеКалендаря.Дата,
		|	ДанныеКалендаря.Год,
		|	ДанныеКалендаря.ВидДня,
		|	ДанныеКалендаря.ДатаПереноса
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеКалендаря
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОшибочныеДанные КАК ОшибочныеДанные
		|		ПО (ОшибочныеДанные.ПроизводственныйКалендарь = ДанныеКалендаря.ПроизводственныйКалендарь)
		|			И (ОшибочныеДанные.Год = ДанныеКалендаря.Год)
		|			И (ГОД(ДанныеКалендаря.Дата) = ДанныеКалендаря.Год)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДанныеКалендаря.ПроизводственныйКалендарь,
		|	ДанныеКалендаря.Год";
		
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда 
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("ПроизводственныйКалендарь") Цикл
		Пока Выборка.СледующийПоЗначениюПоля("Год") Цикл
			НаборЗаписей = РегистрыСведений.ДанныеПроизводственногоКалендаря.СоздатьНаборЗаписей();
			Пока Выборка.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
			КонецЦикла;
			НаборЗаписей.Отбор.ПроизводственныйКалендарь.Установить(Выборка.ПроизводственныйКалендарь);
			НаборЗаписей.Отбор.Год.Установить(Выборка.Год);
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			НаборЗаписей.Записать();
		КонецЦикла;
	КонецЦикла;
	
	// Обновляем связанные графики работы.
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПроизводственныеКалендари.Код КАК КодПроизводственногоКалендаря,
		|	ОшибочныеДанные.Год
		|ИЗ
		|	ВТОшибочныеДанные КАК ОшибочныеДанные
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПроизводственныеКалендари КАК ПроизводственныеКалендари
		|		ПО ОшибочныеДанные.ПроизводственныйКалендарь = ПроизводственныеКалендари.Ссылка";
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	Справочники.ПроизводственныеКалендари.РаспространитьИзмененияДанныхПроизводственныхКалендарей(ТаблицаДанных);
		
КонецПроцедуры

#КонецОбласти
