﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПользовательИБПолноправный = Пользователи.ЭтоПолноправныйПользователь();
	СвойДоступ = Параметры.Пользователь = Пользователи.АвторизованныйПользователь();
	
	ПользовательИБОтветственный =
		НЕ ПользовательИБПолноправный
		И ПравоДоступа("Редактирование", Метаданные.Справочники.ГруппыДоступа);
	
	Элементы.ГруппыДоступаКонтекстноеМенюИзменитьГруппу.Видимость =
		ПользовательИБПолноправный
		ИЛИ ПользовательИБОтветственный;
	
	Элементы.ФормаОтчетПраваДоступа.Видимость =
		ПользовательИБПолноправный
		ИЛИ Параметры.Пользователь = Пользователи.АвторизованныйПользователь();
	
	// Настройка команд для не полноправного пользователя.
	Элементы.ФормаВключитьВГруппу.Видимость   = ПользовательИБОтветственный;
	Элементы.ФормаИсключитьИзГруппы.Видимость = ПользовательИБОтветственный;
	Элементы.ФормаИзменитьГруппу.Видимость    = ПользовательИБОтветственный;
	
	// Настройка команд для полноправного пользователя.
	Элементы.ГруппыДоступаВключитьВГруппу.Видимость   = ПользовательИБПолноправный;
	Элементы.ГруппыДоступаИсключитьИзГруппы.Видимость = ПользовательИБПолноправный;
	Элементы.ГруппыДоступаИзменитьГруппу.Видимость    = ПользовательИБПолноправный;
	
	// Настройка отображения закладок страниц.
	Элементы.ГруппыДоступаИРоли.ОтображениеСтраниц =
		?(ПользовательИБПолноправный,
		  ОтображениеСтраницФормы.ЗакладкиСверху,
		  ОтображениеСтраницФормы.Нет);
	
	// Настройка отображения командной панели для полноправного пользователя.
	Элементы.ГруппыДоступа.ПоложениеКоманднойПанели =
		?(ПользовательИБПолноправный,
		  ПоложениеКоманднойПанелиЭлементаФормы.Верх,
		  ПоложениеКоманднойПанелиЭлементаФормы.Нет);
	
	// Настройка отображения ролей для полноправного пользователя.
	Элементы.ОтображениеРолей.Видимость = ПользовательИБПолноправный;
	
	Если ПользовательИБПолноправный
	 ИЛИ ПользовательИБОтветственный
	 ИЛИ СвойДоступ Тогда
		
		ВывестиГруппыДоступа();
	Иначе
		// Обычному пользователю запрещено просматривать любые настройки чужого доступа.
		Элементы.ГруппыДоступаВключитьВГруппу.Видимость   = Ложь;
		Элементы.ГруппыДоступаИсключитьИзГруппы.Видимость = Ложь;
		
		Элементы.ГруппыДоступаИРоли.Видимость         = Ложь;
		Элементы.НедостаточноПравНаПросмотр.Видимость = Истина;
	КонецЕсли;
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриСозданииФормы");
	ОбработатьИнтерфейсРолей("УстановитьТолькоПросмотрРолей", Истина);
	
	Если ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		Элементы.ФормаВключитьВГруппу.Доступность   = Ложь;
		Элементы.ФормаИсключитьИзГруппы.Доступность = Ложь;
		Элементы.ГруппыДоступаВключитьВГруппу.Доступность   = Ложь;
		Элементы.ГруппыДоступаИсключитьИзГруппы.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ГруппыДоступа")
	 ИЛИ ВРег(ИмяСобытия) = ВРег("Запись_ПрофилиГруппДоступа")
	 ИЛИ ВРег(ИмяСобытия) = ВРег("Запись_ГруппыПользователей")
	 ИЛИ ВРег(ИмяСобытия) = ВРег("Запись_ГруппыВнешнихПользователей") Тогда
		
		ВывестиГруппыДоступа();
		ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриЗагрузкеНастроек", Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГруппыДоступа

&НаКлиенте
Процедура ГруппыДоступаПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные   = Элементы.ГруппыДоступа.ТекущиеДанные;
	ТекущийРодитель = Элементы.ГруппыДоступа.ТекущийРодитель;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		ГруппаДоступаИзменена = ЗначениеЗаполнено(ТекущаяГруппаДоступа);
		ТекущаяГруппаДоступа  = Неопределено;
	Иначе
		НоваяГруппаДоступа    = ?(ТекущийРодитель = Неопределено, ТекущиеДанные.ГруппаДоступа, ТекущийРодитель.ГруппаДоступа);
		ГруппаДоступаИзменена = ТекущаяГруппаДоступа <> НоваяГруппаДоступа;
		ТекущаяГруппаДоступа  = НоваяГруппаДоступа;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыДоступаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ГруппыДоступа.НайтиПоИдентификатору(ВыбраннаяСтрока) <> Неопределено Тогда
		
		Если Элементы.ФормаИзменитьГруппу.Видимость
		 ИЛИ Элементы.ГруппыДоступаИзменитьГруппу.Видимость Тогда
			
			ИзменитьГруппу(Элементы.ФормаИзменитьГруппу);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВГруппу(Команда)
	
	ПараметрыФормы = Новый Структура;
	Выбранные = Новый Массив;
	
	Для каждого ОписаниеГруппыДоступа Из ГруппыДоступа Цикл
		Выбранные.Добавить(ОписаниеГруппыДоступа.ГруппаДоступа);
	КонецЦикла;
	
	ПараметрыФормы.Вставить("Выбранные",         Выбранные);
	ПараметрыФормы.Вставить("ПользовательГрупп", Параметры.Пользователь);
	
	ОткрытьФорму("Справочник.ГруппыДоступа.Форма.ВыборПоОтветственному", ПараметрыФормы, ЭтотОбъект,
		,,, Новый ОписаниеОповещения("ВключитьИсключитьИзГруппы", ЭтотОбъект, Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьИзГруппы(Команда)
	
	Если НЕ ЗначениеЗаполнено(ТекущаяГруппаДоступа) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Группа доступа не выбрана.'"));
		Возврат;
	КонецЕсли;
	
	ВключитьИсключитьИзГруппы(ТекущаяГруппаДоступа, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьГруппу(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	Если НЕ ЗначениеЗаполнено(ТекущаяГруппаДоступа) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Группа доступа не выбрана.'"));
		Возврат;
		
	ИначеЕсли ПользовательИБПолноправный
	      ИЛИ ПользовательИБОтветственный
	          И РазрешеноИзменениеСоставаПользователейГруппы(ТекущаяГруппаДоступа) Тогда
		
		ПараметрыФормы.Вставить("Ключ", ТекущаяГруппаДоступа);
		ОткрытьФорму("Справочник.ГруппыДоступа.ФормаОбъекта", ПараметрыФормы);
	Иначе
		ПоказатьПредупреждение(,
			НСтр("ru = 'Недостаточно прав для редактирования группы доступа.
			           |Редактировать группу доступа могут ответственный за участников группы доступа и администратор.'"));
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ВывестиГруппыДоступа();
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоПравамДоступа(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователь", Параметры.Пользователь);
	
	ОткрытьФорму("Отчет.ПраваДоступа.Форма", ПараметрыФормы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей.

&НаКлиенте
Процедура ГруппировкаРолейПоПодсистемам(Команда)
	
	ОбработатьИнтерфейсРолей("ГруппировкаПоПодсистемам");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВключитьИсключитьИзГруппы(ГруппаДоступа, ВключитьВГруппуДоступа) Экспорт
	
	Если ТипЗнч(ГруппаДоступа) <> Тип("СправочникСсылка.ГруппыДоступа")
	  ИЛИ НЕ ЗначениеЗаполнено(ГруппаДоступа) Тогда
		
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ГруппаДоступа", ГруппаДоступа);
	ДополнительныеПараметры.Вставить("ВключитьВГруппуДоступа", ВключитьВГруппуДоступа);
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().РазделениеВключено
	   И ГруппаДоступа = ПредопределенноеЗначение("Справочник.ГруппыДоступа.Администраторы") Тогда
		
		СтандартныеПодсистемыКлиент.ПриЗапросеПароляДляАутентификацииВСервисе(
			Новый ОписаниеОповещения(
				"ВключитьИсключитьИзГруппыЗавершение", ЭтотОбъект, ДополнительныеПараметры),
			ЭтотОбъект,
			ПарольПользователяСервиса);
		Возврат;
	Иначе
		ВключитьИсключитьИзГруппыЗавершение(Null, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьИсключитьИзГруппыЗавершение(НовыйПарольПользователяСервиса, ДополнительныеПараметры) Экспорт
	
	Если НовыйПарольПользователяСервиса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НовыйПарольПользователяСервиса <> Null Тогда
		ПарольПользователяСервиса = НовыйПарольПользователяСервиса;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	
	ИзменитьСоставГруппы(
		ДополнительныеПараметры.ГруппаДоступа,
		ДополнительныеПараметры.ВключитьВГруппуДоступа,
		ОписаниеОшибки);
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ПоказатьПредупреждение(, ОписаниеОшибки);
	Иначе
		ОповеститьОбИзменении(ДополнительныеПараметры.ГруппаДоступа);
		Оповестить("Запись_ГруппыДоступа", Новый Структура, ДополнительныеПараметры.ГруппаДоступа);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиГруппыДоступа()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Если ПользовательИБПолноправный ИЛИ СвойДоступ Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГруппыДоступа.Ссылка
	|ПОМЕСТИТЬ РазрешенныеГруппыДоступа
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа";
	Запрос.Выполнить();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РазрешенныеГруппыДоступа.Ссылка
	|ИЗ
	|	РазрешенныеГруппыДоступа КАК РазрешенныеГруппыДоступа
	|ГДЕ
	|	(НЕ РазрешенныеГруппыДоступа.Ссылка.ПометкаУдаления)
	|	И (НЕ РазрешенныеГруппыДоступа.Ссылка.Профиль.ПометкаУдаления)";
	РазрешенныеГруппыДоступа = Запрос.Выполнить().Выгрузить();
	РазрешенныеГруппыДоступа.Индексы.Добавить("Ссылка");
	
	Запрос.УстановитьПараметр("Пользователь", Параметры.Пользователь);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка КАК ГруппаДоступа,
	|	ГруппыДоступа.Наименование КАК Наименование,
	|	ГруппыДоступа.Профиль.Наименование КАК ПрофильНаименование,
	|	ГруппыДоступа.Описание КАК Описание,
	|	ГруппыДоступа.Ответственный КАК Ответственный
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	НЕ ГруппыДоступа.ПометкаУдаления
	|	И НЕ ГруппыДоступа.Профиль.ПометкаУдаления
	|	И ИСТИНА В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				ИСТИНА
	|			ИЗ
	|				Справочник.ГруппыДоступа.Пользователи КАК ПользователиГруппДоступа
	|			ГДЕ
	|				ПользователиГруппДоступа.Ссылка = ГруппыДоступа.Ссылка
	|				И НЕ(ПользователиГруппДоступа.Пользователь <> &Пользователь
	|						И НЕ ПользователиГруппДоступа.Пользователь В
	|								(ВЫБРАТЬ
	|									СоставыГруппПользователей.ГруппаПользователей
	|								ИЗ
	|									РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|								ГДЕ
	|									СоставыГруппПользователей.Пользователь = &Пользователь)))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГруппыДоступа.Наименование";
	
	ВсеГруппыДоступа = Запрос.Выполнить().Выгрузить();
	
	// Установка представления для группы доступа.
	// Удаление текущего пользователя из группы доступа, если он входит в нее только непосредственно.
	ЕстьЗапрещенныеГруппы = Ложь;
	Индекс = ВсеГруппыДоступа.Количество()-1;
	
	Пока Индекс >= 0 Цикл
		Строка = ВсеГруппыДоступа[Индекс];
		
		Если РазрешенныеГруппыДоступа.Найти(Строка.ГруппаДоступа, "Ссылка") = Неопределено Тогда
			ВсеГруппыДоступа.Удалить(Индекс);
			ЕстьЗапрещенныеГруппы = Истина;
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ВсеГруппыДоступа, "ГруппыДоступа");
	Элементы.ПредупреждениеЕстьСкрытыеГруппыДоступа.Видимость = ЕстьЗапрещенныеГруппы;
	
	Если НЕ ЗначениеЗаполнено(ТекущаяГруппаДоступа) Тогда
		
		Если ГруппыДоступа.Количество() > 0 Тогда
			ТекущаяГруппаДоступа = ГруппыДоступа[0].ГруппаДоступа;
		КонецЕсли;
	КонецЕсли;
	
	Для каждого ОписаниеГруппыДоступа Из ГруппыДоступа Цикл
		
		Если ОписаниеГруппыДоступа.ГруппаДоступа = ТекущаяГруппаДоступа Тогда
			Элементы.ГруппыДоступа.ТекущаяСтрока = ОписаниеГруппыДоступа.ПолучитьИдентификатор();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПользовательИБПолноправный Тогда
		ЗаполнитьРоли();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьСоставГруппы(Знач ГруппаДоступа, Знач Добавить, ОписаниеОшибки = "")
	
	Если НЕ РазрешеноИзменениеСоставаПользователейГруппы(ГруппаДоступа) Тогда
		Если Добавить Тогда
			ОписаниеОшибки =
				НСтр("ru = 'Невозможно включить пользователя в группу доступа,
				           |так как текущий пользователь
				           |не ответственный за участников группы доступа и
				           |не полноправный администратор.'");
		Иначе
			ОписаниеОшибки =
				НСтр("ru = 'Невозможно исключить пользователя из группы доступа,
				           |так как текущий пользователь
				           |не ответственный за участников группы доступа и
				           |не полноправный администратор.'");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если НЕ Добавить И НЕ ПользовательВключенВГруппуДоступа(ТекущаяГруппаДоступа) Тогда
		ОписаниеОшибки =
			НСтр("ru = 'Невозможно исключить пользователя из группы доступа,
			           |так как он включен в нее косвенно.'");
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
	   И ГруппаДоступа = Справочники.ГруппыДоступа.Администраторы
	   И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ПользователиВМоделиСервиса") Тогда
		
		МодульПользователиСлужебныйВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ПользователиСлужебныйВМоделиСервиса");
		ДействияСПользователемСервиса = МодульПользователиСлужебныйВМоделиСервиса.ПолучитьДействияСПользователемСервиса();
		
		Если НЕ ДействияСПользователемСервиса.ИзменениеАдминистративногоДоступа Тогда
			ВызватьИсключение
				НСтр("ru = 'Не достаточно прав доступа для изменения состава администраторов.'");
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ГруппаДоступаОбъект = ГруппаДоступа.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ГруппаДоступаОбъект.Ссылка, ГруппаДоступаОбъект.ВерсияДанных);
	Если Добавить Тогда
		Если ГруппаДоступаОбъект.Пользователи.Найти(Параметры.Пользователь, "Пользователь") = Неопределено Тогда
			ГруппаДоступаОбъект.Пользователи.Добавить().Пользователь = Параметры.Пользователь;
		КонецЕсли;
	Иначе
		СтрокаТЧ = ГруппаДоступаОбъект.Пользователи.Найти(Параметры.Пользователь, "Пользователь");
		Если СтрокаТЧ <> Неопределено Тогда
			ГруппаДоступаОбъект.Пользователи.Удалить(СтрокаТЧ);
		КонецЕсли;
	КонецЕсли;
	
	Если ГруппаДоступаОбъект.Ссылка = Справочники.ГруппыДоступа.Администраторы Тогда
		
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			ГруппаДоступаОбъект.ДополнительныеСвойства.Вставить(
				"ПарольПользователяСервиса", ПарольПользователяСервиса);
		Иначе
			УправлениеДоступомСлужебный.ПроверитьНаличиеПользователяИБВГруппеДоступаАдминистраторы(
				ГруппаДоступаОбъект.Пользователи, ОписаниеОшибки);
			
			Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		ГруппаДоступаОбъект.Записать();
	Исключение
		ПарольПользователяСервиса = Неопределено;
		ВызватьИсключение;
	КонецПопытки;
	
	РазблокироватьДанныеДляРедактирования(ГруппаДоступаОбъект.Ссылка);
	
	ТекущаяГруппаДоступа = ГруппаДоступаОбъект.Ссылка;
	
КонецПроцедуры

&НаСервере
Функция РазрешеноИзменениеСоставаПользователейГруппы(ГруппаДоступа)
	
	Если ПользовательИБПолноправный Тогда
		Возврат Истина;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГруппаДоступа",              ГруппаДоступа);
	Запрос.УстановитьПараметр("АвторизованныйПользователь", Пользователи.АвторизованныйПользователь());
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|		ПО (СоставыГруппПользователей.Пользователь = &АвторизованныйПользователь)
	|			И (СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступа.Ответственный)
	|			И (ГруппыДоступа.Ссылка = &ГруппаДоступа)";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Функция ПользовательВключенВГруппуДоступа(ГруппаДоступа)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГруппаДоступа", ГруппаДоступа);
	Запрос.УстановитьПараметр("Пользователь", Параметры.Пользователь);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|ГДЕ
	|	ГруппыДоступаПользователи.Ссылка = &ГруппаДоступа
	|	И ГруппыДоступаПользователи.Пользователь = &Пользователь";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьРоли()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Параметры.Пользователь);
	
	Если ТипЗнч(Параметры.Пользователь) = Тип("СправочникСсылка.Пользователи")
	 ИЛИ ТипЗнч(Параметры.Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ 
		|	Роли.Роль.Имя КАК Роль
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа.Роли КАК Роли
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|			ПО (СоставыГруппПользователей.Пользователь = &Пользователь)
		|				И (СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступаПользователи.Пользователь)
		|				И (НЕ ГруппыДоступаПользователи.Ссылка.ПометкаУдаления)
		|		ПО Роли.Ссылка = ГруппыДоступаПользователи.Ссылка.Профиль
		|			И (НЕ Роли.Ссылка.ПометкаУдаления)";
	Иначе
		// Группа пользователей или Группа внешних пользователей.
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Роли.Роль.Имя КАК Роль
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа.Роли КАК Роли
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ПО (ГруппыДоступаПользователи.Пользователь = &Пользователь)
		|			И (НЕ ГруппыДоступаПользователи.Ссылка.ПометкаУдаления)
		|			И Роли.Ссылка = ГруппыДоступаПользователи.Ссылка.Профиль
		|			И (НЕ Роли.Ссылка.ПометкаУдаления)";
	КонецЕсли;
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(), "ПрочитанныеРоли");
	
	Отбор = Новый Структура("Роль", "ПолныеПрава");
	Если ПрочитанныеРоли.НайтиСтроки(Отбор).Количество() > 0 Тогда
		
		Отбор = Новый Структура("Роль", "АдминистраторСистемы");
		Если ПрочитанныеРоли.НайтиСтроки(Отбор).Количество() > 0 Тогда
			
			ПрочитанныеРоли.Очистить();
			ПрочитанныеРоли.Добавить().Роль = "ПолныеПрава";
			ПрочитанныеРоли.Добавить().Роль = "АдминистраторСистемы";
		Иначе
			ПрочитанныеРоли.Очистить();
			ПрочитанныеРоли.Добавить().Роль = "ПолныеПрава";
		КонецЕсли;
	КонецЕсли;
	
	ОбработатьИнтерфейсРолей("ОбновитьДеревоРолей");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей.

&НаСервере
Процедура ОбработатьИнтерфейсРолей(Действие, ОсновнойПараметр = Неопределено)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ОсновнойПараметр", ОсновнойПараметр);
	ПараметрыДействия.Вставить("Форма",            ЭтотОбъект);
	ПараметрыДействия.Вставить("КоллекцияРолей",   ПрочитанныеРоли);
	
	Если ТипЗнч(Параметры.Пользователь) = Тип("СправочникСсылка.Пользователи")
	   И Пользователи.ЭтоПолноправныйПользователь(Параметры.Пользователь, Ложь, Ложь) Тогда
		
		НазначениеРолей = "ДляАдминистраторов";
		
	ИначеЕсли ТипЗнч(Параметры.Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи")
	      Или ТипЗнч(Параметры.Пользователь) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
		
		НазначениеРолей = "ДляВнешнихПользователей";
	Иначе
		НазначениеРолей = "ДляПользователей";
	КонецЕсли;
	
	ПараметрыДействия.Вставить("НазначениеРолей", НазначениеРолей);
	
	ПользователиСлужебный.ОбработатьИнтерфейсРолей(Действие, ПараметрыДействия);
	
КонецПроцедуры

#КонецОбласти
