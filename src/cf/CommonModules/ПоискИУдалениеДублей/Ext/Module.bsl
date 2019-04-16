﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Поиск и удаление дублей".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Поиск дублей для указанного значения.
//
// Параметры:
//     ОбластьПоиска - Строка - Имя таблицы данных (полное имя метаданных) области поиска.
//                              Например "Справочник.Номенклатура". Поддерживается поиск в справочниках, 
//                              планах видов характеристик, видах расчетов, планах счетов.
//
//     Элемент - Произвольный - объект с данными элемента, для которого производится поиск дублей.
//
//     ДополнительныеПараметры - Произвольный - Параметр для передачи в обработчики событий менеджера.
//
// Возвращаемое значение:
//     ТаблицаЗначений - содержит строки с описаниями дублей.
// 
Функция НайтиДублиЭлемента(Знач ОбластьПоиска, Знач ЭталонныйОбъект, Знач ДополнительныеПараметры) Экспорт
	
	ПараметрыПоискаДублей = Новый Структура;
	ПараметрыПоискаДублей.Вставить("КомпоновщикПредварительногоОтбора");
	ПараметрыПоискаДублей.Вставить("ОбластьПоискаДублей", ОбластьПоиска);
	ПараметрыПоискаДублей.Вставить("УчитыватьПрикладныеПравила", Истина);
	
	// Из параметров
	ПараметрыПоискаДублей.Вставить("ПравилаПоиска", Новый ТаблицаЗначений);
	ПараметрыПоискаДублей.ПравилаПоиска.Колонки.Добавить("Реквизит", Новый ОписаниеТипов("Строка"));
	ПараметрыПоискаДублей.ПравилаПоиска.Колонки.Добавить("Правило",  Новый ОписаниеТипов("Строка"));
	
	// См. Обработка.ПоискИУдалениеДублей
	ПараметрыПоискаДублей.КомпоновщикПредварительногоОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	МетаОбласть = Метаданные.НайтиПоПолномуИмени(ОбластьПоиска);
	ДоступныеРеквизитыОтбора = ДоступныеИменаМетаРеквизитовОтбора(МетаОбласть.СтандартныеРеквизиты);
	ДоступныеРеквизитыОтбора = ?(ПустаяСтрока(ДоступныеРеквизитыОтбора), ",", ДоступныеРеквизитыОтбора)
		+ ДоступныеИменаМетаРеквизитовОтбора(МетаОбласть.Реквизиты);
	
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = СхемаКомпоновки.ИсточникиДанных.Добавить();
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Запрос = "ВЫБРАТЬ " + Сред(ДоступныеРеквизитыОтбора, 2) + " ИЗ " + ОбластьПоиска;
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	
	ПараметрыПоискаДублей.КомпоновщикПредварительногоОтбора.Инициализировать( Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки) );
	
	// Вызов прикладного кода
	ОбработкаПоиска = Обработки.ПоискИУдалениеДублей.Создать();
	
	ИспользоватьПрикладныеПравила = ОбработкаПоиска.ЕстьПрикладныеПравилаОбластиПоискаДублей(ОбластьПоиска);
	Если ИспользоватьПрикладныеПравила Тогда
		ПрикладныеПараметры = Новый Структура;
		ПрикладныеПараметры.Вставить("ПравилаПоиска",        ПараметрыПоискаДублей.ПравилаПоиска);
		ПрикладныеПараметры.Вставить("КомпоновщикОтбора",    ПараметрыПоискаДублей.КомпоновщикПредварительногоОтбора);
		ПрикладныеПараметры.Вставить("ОграниченияСравнения", Новый Массив);
		ПрикладныеПараметры.Вставить("КоличествоЭлементовДляСравнения", 1500);
		
		МенеджерОбластиПоиска = ОбработкаПоиска.МенеджерОбластиПоискаДублей(ОбластьПоиска);
		МенеджерОбластиПоиска.ПараметрыПоискаДублей(ПрикладныеПараметры, ДополнительныеПараметры);
		
		ПараметрыПоискаДублей.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	КонецЕсли;
	
	ГруппыДублей = ОбработкаПоиска.ГруппыДублей(ПараметрыПоискаДублей, ЭталонныйОбъект);
	Результат = ГруппыДублей.ТаблицаДублей;
	
	// Там ровно одна группа, возвращаем нужные элементы.
	Для Каждого Строка Из Результат.НайтиСтроки(Новый Структура("Родитель", Неопределено)) Цикл
		Результат.Удалить(Строка);
	КонецЦикла;
	ПустаяСсылка = МенеджерОбластиПоиска.ПустаяСсылка();
	Для Каждого Строка Из Результат.НайтиСтроки(Новый Структура("Ссылка", ПустаяСсылка)) Цикл
		Результат.Удалить(Строка);
	КонецЦикла;
	
	Возврат Результат; 
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.ВариантыОтчетов\ПриНастройкеВариантовОтчетов"].Добавить(
			"ПоискИУдалениеДублей");
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьВозможностьЗаменыЭлементовСтрока(ПарыЗамен, ПараметрыЗамены) Экспорт
	
	Результат = "";
	Ошибки = ПроверитьВозможностьЗаменыЭлементов(ПарыЗамен, ПараметрыЗамены);
	Для Каждого КлючЗначение Из Ошибки Цикл
		Результат = Результат + Символы.ПС + КлючЗначение.Значение;
	КонецЦикла;
	Возврат СокрЛП(Результат);
	
КонецФункции

Функция ПроверитьВозможностьЗаменыЭлементов(ПарыЗамен, ПараметрыЗамены) Экспорт
	
	Если ПарыЗамен.Количество() = 0 Тогда
		Возврат Новый Соответствие;
	КонецЕсли;
	
	Для Каждого Элемент Из ПарыЗамен Цикл
		ПервыйЭлемент = Элемент.Ключ;
		Прервать;
	КонецЦикла;
	
	МодульМенеджера = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ПервыйЭлемент);
	
	СписокОбъектов = Новый Соответствие;
	ПоискИУдалениеДублейПереопределяемый.ПриОпределенииОбъектовСПоискомДублей(СписокОбъектов);
	СведенияОбОбъекте = СписокОбъектов[ПервыйЭлемент.Метаданные().ПолноеИмя()];
	
	Если СведенияОбОбъекте <> Неопределено И (СведенияОбОбъекте = "" Или СтрНайти(СведенияОбОбъекте, "ВозможностьЗаменыЭлементов") > 0) Тогда
		Возврат МодульМенеджера.ВозможностьЗаменыЭлементов(ПарыЗамен, ПараметрыЗамены);
	КонецЕсли;
	
	Возврат Новый Соответствие;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Содержит настройки размещения вариантов отчетов в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Содержит настройки всех отчетов и вариантов конфигурации.
//       Используется для передачи в параметрах вспомогательных методов.
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   1. Функции ОписаниеОтчета и ОписаниеВарианта формируют описание настроек отчета и варианта для последующего изменения:
//       НастройкиОтчета   = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.<ИмяОтчета>);
//       НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//       Возвращаемые коллекции содержат одинаковый набор свойств.
//       НастройкиОтчета используются как умолчания для вариантов, описания которых еще не получены.
//       Подробнее - см. "свойства для изменения" в комментарии к ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//   2. Процедура УстановитьРежимВыводаВПанеляхОтчетов позволяет настроить режим группировки вариантов в панелях отчетов:
//       ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь);
//       ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Метаданные.Отчеты.<ИмяОтчета>, Истина/Ложь);
//       ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Метаданные.Подсистемы.<ИмяПодсистемы>, Истина/Ложь);
//   3. Процедура НастроитьОтчетВМодулеМенеджера позволяет переопределять настройки отчета в его модуле менеджера:
//       ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.<ИмяОтчета>);
//
Процедура ПриНастройкеВариантовОтчетов(Настройки) Экспорт
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.МестаИспользованияСсылок);
КонецПроцедуры

// См. Обработка.ПоискИУдалениеДублей
Функция ДоступныеИменаМетаРеквизитовОтбора(Знач МетаКоллекция)
	Результат = "";
	ТипХранилища = Тип("ХранилищеЗначения");
	
	Для Каждого МетаРеквизит Из МетаКоллекция Цикл
		ЭтоХранилище = МетаРеквизит.Тип.СодержитТип(ТипХранилища);
		Если Не ЭтоХранилище Тогда
			Результат = Результат + "," + МетаРеквизит.Имя;
		КонецЕсли
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Процедура ОпределитьМестаИспользования(Знач НаборСсылок, Знач АдресРезультата) Экспорт
	
	ТаблицаПоиска = ОбщегоНазначения.МестаИспользования(НаборСсылок);
	
	Фильтр = Новый Структура("ВспомогательныеДанные", Ложь);
	АктуальныеСтроки = ТаблицаПоиска.НайтиСтроки(Фильтр);
	
	Результат = ТаблицаПоиска.Скопировать(АктуальныеСтроки, "Ссылка");
	Результат.Колонки.Добавить("Вхождения", Новый ОписаниеТипов("Число"));
	Результат.ЗаполнитьЗначения(1, "Вхождения");
	
	Результат.Свернуть("Ссылка", "Вхождения");
	Для Каждого Ссылка Из НаборСсылок Цикл
		Если Результат.Найти(Ссылка, "Ссылка") = Неопределено Тогда
			Результат.Добавить().Ссылка = Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
КонецПроцедуры

// Производит замену ссылок во всех данных. 
//
// Параметры:
//
//     ПараметрыЗамены - Структура - со свойствами ПарыЗамен и Параметры, 
//                                   которые соответствуют одноименным параметрам ОбщегоНазначения.ЗаменитьСсылки.
//     АдресРезультата - Строка - адрес временного хранилища, куда будет помещен результат замены - ТаблицаЗначений:
//       * Ссылка - ЛюбаяСсылка - Ссылка, которую заменяли.
//       * ОбъектОшибки - Произвольный - Объект - причина ошибки.
//       * ПредставлениеОбъектаОшибки - Строка - Строковое представление объекта ошибки.
//       * ТипОшибки - Строка - Маркер типа ошибки. Возможны варианты:
//                              "ОшибкаБлокировки"  - при обработке ссылки некоторые объекты были заблокированы
//                              "ДанныеИзменены"    - в процессе обработки данные были изменены другим пользователем
//                              "ОшибкаЗаписи"      - не смогли записать объект
//                              "НеизвестныеДанные" - при обработке были найдены данные, которые
//                                                    не планировались к анализу, замена не реализована
//                              "ЗаменаЗапрещена"   - метод ВозможностьЗаменыЭлементов вернул отказ.
//       * ТекстОшибки - Строка - Подробное описание ошибки.
//
Процедура ЗаменитьСсылки(ПараметрыЗамены, Знач АдресРезультата) Экспорт
	
	Результат = ОбщегоНазначения.ЗаменитьСсылки(ПараметрыЗамены.ПарыЗамен, ПараметрыЗамены.Параметры);
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

// Формирует таблицу обслуживаемых объектов метаданных и их общие настройки.
//
// Возвращаемое значение:
//   ТаблицаЗначений - Заполняемый список, в котором устанавливаются:
//       * ПолноеИмя             - Строка   - Полное имя метаданных объекта-таблицы.
//       * ПредставлениеЭлемента - Строка   - Представление элемента для пользователя.
//       * ПредставлениеСписка   - Строка   - Представление списка для пользователя.
//       * Удален                - Булево   - Флаг того, что объект метаданных с префиксом "Удалить".
//       * СобытиеПараметрыПоискаДублей      - Булево - Флаг подписки на соответствующее событие.
//       * СобытиеПриПоискеДублей            - Булево - Флаг подписки на соответствующее событие.
//       * СобытиеВозможностьЗаменыЭлементов - Булево - Флаг подписки на соответствующее событие.
//
Функция НастройкиОбъектовМетаданных() Экспорт
	Настройки = Новый ТаблицаЗначений;
	Настройки.Колонки.Добавить("Вид",                   Новый ОписаниеТипов("Строка"));
	Настройки.Колонки.Добавить("ПолноеИмя",             Новый ОписаниеТипов("Строка"));
	Настройки.Колонки.Добавить("ПредставлениеЭлемента", Новый ОписаниеТипов("Строка"));
	Настройки.Колонки.Добавить("ПредставлениеСписка",   Новый ОписаниеТипов("Строка"));
	Настройки.Колонки.Добавить("Удален",                Новый ОписаниеТипов("Булево"));
	Настройки.Колонки.Добавить("СобытиеПараметрыПоискаДублей",      Новый ОписаниеТипов("Булево"));
	Настройки.Колонки.Добавить("СобытиеПриПоискеДублей",            Новый ОписаниеТипов("Булево"));
	Настройки.Колонки.Добавить("СобытиеВозможностьЗаменыЭлементов", Новый ОписаниеТипов("Булево"));
	
	ВсеПодключенныеСобытия = Новый Соответствие;
	ПоискИУдалениеДублейПереопределяемый.ПриОпределенииОбъектовСПоискомДублей(ВсеПодключенныеСобытия);
	
	ЗарегистрироватьКоллекциюМетаданных(Настройки, ВсеПодключенныеСобытия, Метаданные.Справочники, "Справочник");
	ЗарегистрироватьКоллекциюМетаданных(Настройки, ВсеПодключенныеСобытия, Метаданные.Документы, "Документ");
	ЗарегистрироватьКоллекциюМетаданных(Настройки, ВсеПодключенныеСобытия, Метаданные.ПланыСчетов, "ПланСчетов");
	ЗарегистрироватьКоллекциюМетаданных(Настройки, ВсеПодключенныеСобытия, Метаданные.ПланыВидовРасчета, "ПланВидовРасчета");
	
	Результат = Настройки.Скопировать(Новый Структура("Удален", Ложь));
	Результат.Сортировать("ПредставлениеСписка");
	
	Возврат Результат;
КонецФункции

Процедура ЗарегистрироватьКоллекциюМетаданных(Настройки, ВсеПодключенныеСобытия, КоллекцияМетаданных, Вид)
	СтандартныеСвойства = Новый Структура("ПредставлениеОбъекта, РасширенноеПредставлениеОбъекта, ПредставлениеСписка, РасширенноеПредставлениеСписка");
	
	Для Каждого ОбъектМетаданных Из КоллекцияМетаданных Цикл
		Если Не ПравоДоступа("Просмотр", ОбъектМетаданных)
			Или Не ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных) Тогда
			Продолжить; // Нет доступа, не выводим в список.
		КонецЕсли;
		
		СтрокаТаблицы = Настройки.Добавить();
		СтрокаТаблицы.Вид = Вид;
		СтрокаТаблицы.ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
		СтрокаТаблицы.Удален = СтрНачинаетсяС(ОбъектМетаданных.Имя, "Удалить");
		
		ЗаполнитьЗначенияСвойств(СтандартныеСвойства, ОбъектМетаданных);
		Если ЗначениеЗаполнено(СтандартныеСвойства.ПредставлениеОбъекта) Тогда
			СтрокаТаблицы.ПредставлениеЭлемента = СтандартныеСвойства.ПредставлениеОбъекта;
		ИначеЕсли ЗначениеЗаполнено(СтандартныеСвойства.РасширенноеПредставлениеОбъекта) Тогда
			СтрокаТаблицы.ПредставлениеЭлемента = СтандартныеСвойства.РасширенноеПредставлениеОбъекта;
		Иначе
			СтрокаТаблицы.ПредставлениеЭлемента = ОбъектМетаданных.Представление();
		КонецЕсли;
		Если ЗначениеЗаполнено(СтандартныеСвойства.ПредставлениеСписка) Тогда
			СтрокаТаблицы.ПредставлениеСписка = СтандартныеСвойства.ПредставлениеСписка;
		ИначеЕсли ЗначениеЗаполнено(СтандартныеСвойства.РасширенноеПредставлениеСписка) Тогда
			СтрокаТаблицы.ПредставлениеСписка = СтандартныеСвойства.РасширенноеПредставлениеСписка;
		Иначе
			СтрокаТаблицы.ПредставлениеСписка = ОбъектМетаданных.Представление();
		КонецЕсли;
		
		События = ВсеПодключенныеСобытия[СтрокаТаблицы.ПолноеИмя];
		Если ТипЗнч(События) = Тип("Строка") Тогда
			Если ПустаяСтрока(События) Тогда
				СтрокаТаблицы.СобытиеПараметрыПоискаДублей      = Истина;
				СтрокаТаблицы.СобытиеПриПоискеДублей            = Истина;
				СтрокаТаблицы.СобытиеВозможностьЗаменыЭлементов = Истина;
			Иначе
				СтрокаТаблицы.СобытиеПараметрыПоискаДублей      = СтрНайти(События, "ПараметрыПоискаДублей") > 0;
				СтрокаТаблицы.СобытиеПриПоискеДублей            = СтрНайти(События, "ПриПоискеДублей") > 0;
				СтрокаТаблицы.СобытиеВозможностьЗаменыЭлементов = СтрНайти(События, "ВозможностьЗаменыЭлементов") > 0;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Представление подсистемы. Используется при записи в журнал регистрации и в других местах.
Функция НаименованиеПодсистемы(ДляПользователя) Экспорт
	КодЯзыка = ?(ДляПользователя, ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка(), "");
	Возврат НСтр("ru = 'Поиск и удаление дублей'", КодЯзыка);
КонецФункции

#КонецОбласти