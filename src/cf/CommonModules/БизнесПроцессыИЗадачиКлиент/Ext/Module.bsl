﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-процессы и задачи".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Команды работы с бизнес-процессами.

// Отмечает указанный бизнес-процесс как остановленный.
//
Процедура Остановить(Знач ПараметрКоманды) Экспорт
	
	ТекстВопроса = "";
	ЧислоЗадач = 0;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		
		Если ПараметрКоманды.Количество() = 0 Тогда
			ПоказатьПредупреждение(,НСтр("ru= 'Не выбран ни один бизнес-процесс.'"));
			Возврат;
		КонецЕсли;	
		
		Если ПараметрКоманды.Количество() = 1 И ТипЗнч(ПараметрКоманды[0]) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			ПоказатьПредупреждение(,НСтр("ru= 'Не выбран ни один бизнес-процесс.'"));
			Возврат;
		КонецЕсли;	
		
		ЧислоЗадач = БизнесПроцессыИЗадачиВызовСервера.КоличествоНевыполненныхЗадачБизнесПроцессов(ПараметрКоманды);
		Если ПараметрКоманды.Количество() = 1 Тогда
			Если ЧислоЗадач > 0 Тогда
				ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Будет выполнена остановка бизнес-процесса ""%1"" и всех его невыполненных задач (%2). Продолжить?'"), 
					Строка(ПараметрКоманды[0]), ЧислоЗадач);
			Иначе
				ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Будет выполнена остановка бизнес-процесса ""%1"". Продолжить?'"), 
					Строка(ПараметрКоманды[0]));
			КонецЕсли;		
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Будет выполнена остановка бизнес-процессов (%1) и всех их невыполненных задач (%2). Продолжить?'"), 
				ПараметрКоманды.Количество(), ЧислоЗадач);
		КонецЕсли;		
		
	Иначе
		
		Если ТипЗнч(ПараметрКоманды) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			ПоказатьПредупреждение(,НСтр("ru= 'Не выбран ни один бизнес-процесс'"));
			Возврат;
		КонецЕсли;	
		
		ЧислоЗадач = БизнесПроцессыИЗадачиВызовСервера.КоличествоНевыполненныхЗадачБизнесПроцесса(ПараметрКоманды);
		Если ЧислоЗадач > 0 Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Будет выполнена остановка бизнес-процесса ""%1"" и всех его невыполненных задач (%2). Продолжить?'"), 
				Строка(ПараметрКоманды), ЧислоЗадач);
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Будет выполнена остановка бизнес-процесса ""%1"". Продолжить?'"), 
				Строка(ПараметрКоманды));
		КонецЕсли;		
			
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ОстановитьЗавершение", ЭтотОбъект, ПараметрКоманды);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Остановка бизнес-процесса'"));
	
КонецПроцедуры

// Отмечает указанный бизнес-процесс как остановленный.
// Предназначена для вызова из формы бизнес-процесса.
//
Процедура ОстановитьБизнесПроцессИзФормыОбъекта(Форма) Экспорт
	
	Форма.Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Остановлен");
	Форма.Записать();
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Бизнес-процесс остановлен'"),
		ПолучитьНавигационнуюСсылку(Форма.Объект.Ссылка),
		Строка(Форма.Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	ОповеститьОбИзменении(Форма.Объект.Ссылка);
	
КонецПроцедуры

// Отмечает указанный бизнес-процесс как активный.
//
Процедура СделатьАктивным(Знач ПараметрКоманды) Экспорт
	
	ТекстВопроса = "";
	ЧислоЗадач = 0;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		
		Если ПараметрКоманды.Количество() = 0 Тогда
			ПоказатьПредупреждение(,НСтр("ru= 'Не выбран ни один бизнес-процесс.'"));
			Возврат;
		КонецЕсли;	
		
		Если ПараметрКоманды.Количество() = 1 И ТипЗнч(ПараметрКоманды[0]) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			ПоказатьПредупреждение(,НСтр("ru= 'Не выбран ни один бизнес-процесс.'"));
			Возврат;
		КонецЕсли;	
		
		ЧислоЗадач = БизнесПроцессыИЗадачиВызовСервера.КоличествоНевыполненныхЗадачБизнесПроцессов(ПараметрКоманды);
		Если ПараметрКоманды.Количество() = 1 Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Бизнес-процесс ""%1"" и все его задачи (%2) будут сделаны активными. Продолжить?'"), 
				Строка(ПараметрКоманды[0]), ЧислоЗадач);
		Иначе		
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Бизнес-процессы (%1) и их задачи (%2) будут сделаны активными. Продолжить?'"), 
				ПараметрКоманды.Количество(), ЧислоЗадач);
		КонецЕсли;		
		
	Иначе
		
		Если ТипЗнч(ПараметрКоманды) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			ПоказатьПредупреждение(,НСтр("ru= 'Не выбран ни один бизнес-процесс.'"));
			Возврат;
		КонецЕсли;	
		
		ЧислоЗадач = БизнесПроцессыИЗадачиВызовСервера.КоличествоНевыполненныхЗадачБизнесПроцесса(ПараметрКоманды);
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Бизнес-процесс ""%1"" и все его задачи (%2) будут сделаны активными. Продолжить?'"), 
			Строка(ПараметрКоманды), ЧислоЗадач);
			
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("СделатьАктивнымЗавершение", ЭтотОбъект, ПараметрКоманды);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Остановка бизнес-процесса'"));
	
КонецПроцедуры

// Отмечает указанный бизнес-процесс как активный.
// Предназначена для вызова из формы бизнес-процесса.
//
Процедура ПродолжитьБизнесПроцессИзФормыОбъекта(Форма) Экспорт
	
	Форма.Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Активен");
	Форма.Записать();
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Бизнес-процесс сделан активным'"),
		ПолучитьНавигационнуюСсылку(Форма.Объект.Ссылка),
		Строка(Форма.Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	ОповеститьОбИзменении(Форма.Объект.Ссылка);
	
КонецПроцедуры

// Отмечает указанные задачи как принятые к исполнению.
//
Процедура ПринятьЗадачиКИсполнению(Знач МассивЗадач) Экспорт
	
	БизнесПроцессыИЗадачиВызовСервера.ПринятьЗадачиКИсполнению(МассивЗадач);
	Если МассивЗадач.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	ИначеЕсли МассивЗадач.Количество() <> 1 Тогда
		Состояние(НСтр("ru = 'Задачи приняты к исполнению.'"));
	Иначе		
		Состояние(НСтр("ru = 'Задача принята к исполнению.'"));
	КонецЕсли;	
	
	ТипЗначенияЗадачи = Неопределено;
	Для каждого Задача Из МассивЗадач Цикл
		Если ТипЗнч(Задача) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда 
			ТипЗначенияЗадачи = ТипЗнч(Задача);
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
	Если ТипЗначенияЗадачи <> Неопределено Тогда
		ОповеститьОбИзменении(ТипЗначенияЗадачи);
	КонецЕсли;	
	
КонецПроцедуры

// Отмечает указанную задачу как принятую к исполнению.
//
Процедура ПринятьЗадачуКИсполнению(Форма, ТекущийПользователь) Экспорт
	
	Форма.Объект.ПринятаКИсполнению = Истина;
	
	// ДатаПринятияКИсполнению устанавливается пустой - она будет проинициализирована 
	// текущей датой сеанса перед записью самой  задачи.
	Форма.Объект.ДатаПринятияКИсполнению = Дата('00010101');
	Если НЕ ЗначениеЗаполнено(Форма.Объект.Исполнитель) Тогда
		Форма.Объект.Исполнитель = ТекущийПользователь;
	КонецЕсли;
	
	Форма.Записать();
	Состояние(НСтр("ru = 'Задача принята к исполнению.'"));
	ОбновитьДоступностьКомандПринятияКИсполнению(Форма);
	ОповеститьОбИзменении(Форма.Объект.Ссылка);
	
КонецПроцедуры

// Отмечает указанные задачи как не принятые к исполнению.
//
Процедура ОтменитьПринятиеЗадачКИсполнению(Знач МассивЗадач) Экспорт
	
	БизнесПроцессыИЗадачиВызовСервера.ОтменитьПринятиеЗадачКИсполнению(МассивЗадач);
	Если МассивЗадач.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	ИначеЕсли МассивЗадач.Количество() <> 1 Тогда
		Состояние(НСтр("ru = 'Задачи помечены как НЕ принятые к исполнению.'"));
	Иначе		
		Состояние(НСтр("ru = 'Задача помечена как НЕ принятая к исполнению.'"));
	КонецЕсли;		
	
	ТипЗначенияЗадачи = Неопределено;
	Для каждого Задача Из МассивЗадач Цикл
		Если ТипЗнч(Задача) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда 
			ТипЗначенияЗадачи = ТипЗнч(Задача);
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
	Если ТипЗначенияЗадачи <> Неопределено Тогда
		ОповеститьОбИзменении(ТипЗначенияЗадачи);
	КонецЕсли;	
	
КонецПроцедуры

// Отмечает указанную задачу как не принятую к исполнению.
//
Процедура ОтменитьПринятиеЗадачиКИсполнению(Форма) Экспорт
	
	Форма.Объект.ПринятаКИсполнению = Ложь;
	Форма.Объект.ДатаПринятияКИсполнению = "00010101000000";
	Если Не Форма.Объект.РольИсполнителя.Пустая() Тогда
		Форма.Объект.Исполнитель = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	КонецЕсли;	
	
	Форма.Записать();
	Состояние(НСтр("ru = 'Задача помечена как НЕ принятая к исполнению.'"));
	ОбновитьДоступностьКомандПринятияКИсполнению(Форма);
	ОповеститьОбИзменении(Форма.Объект.Ссылка);
	
КонецПроцедуры

// Устанавливает доступность команд принятия к исполнению.
//
Процедура ОбновитьДоступностьКомандПринятияКИсполнению(Форма) Экспорт
	
	Если Форма.Объект.ПринятаКИсполнению = Истина Тогда
		Форма.Элементы.ФормаПринятьКИсполнению.Доступность = Ложь;
		
		Если Форма.Объект.Выполнена Тогда
			Форма.Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Ложь;
		Иначе
			Форма.Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Истина;
		КонецЕсли;
		
	Иначе	
		Форма.Элементы.ФормаПринятьКИсполнению.Доступность = Истина;
		Форма.Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Ложь;
	КонецЕсли;	
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Дополнительные процедуры и функции.

// Стандартный обработчик оповещения для форм выполнения задач.
// Для вызова из обработчика события формы ОбработкаОповещения.
//
// Параметры:
//  Форма       - УправляемаяФорма  - форма выполнения задачи.
//  ИмяСобытия  - Строка            - имя события.
//  Параметр    - произвольный тип  - параметр события.
//  Источник    - произвольный тип  - источник события.
//
Процедура ФормаЗадачиОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" 
		И НЕ Форма.Модифицированность 
		И (Источник = Форма.Объект.Ссылка ИЛИ (ТипЗнч(Источник) = Тип("Массив") 
		И Источник.Найти(Форма.Объект.Ссылка) <> Неопределено)) Тогда
		Если Параметр.Свойство("Перенаправлена") Тогда
			Форма.Закрыть();
		Иначе
			Форма.Прочитать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Стандартный обработчик ПередНачаломДобавления для списков задач.
// Для вызова из обработчика события таблицы формы ПередНачаломДобавления.
//
// Параметры:
//   аналогичны параметрам обработчика таблицы формы ПередНачаломДобавления.
//
Процедура СписокЗадачПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	Если Копирование Тогда
		Задача = Элемент.ТекущаяСтрока;
		Если НЕ ЗначениеЗаполнено(Задача) Тогда
			Возврат;
		КонецЕсли;
		ПараметрыФормы = Новый Структура("Основание", Задача);
	КонецЕсли;
	СоздатьЗадание(Форма, ПараметрыФормы);
	Отказ = Истина;
	
КонецПроцедуры

// Записать и закрыть форму выполнения задачи.
//
// Параметры:
//  Форма  - УправляемаяФорма - форма выполнения задачи.
//  ВыполнитьЗадачу  - Булево - задача записывается в режиме выполнения.
//  ПараметрыОповещения - Структура - дополнительные параметры оповещения.
//
// Возвращаемое значение:
//   Булево   - Истина, если запись прошла успешно.
//
Функция ЗаписатьИЗакрытьВыполнить(Форма, ВыполнитьЗадачу = Ложь, ПараметрыОповещения = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	НовыйОбъект = Форма.Объект.Ссылка.Пустая();
	ТекстОповещения = "";
	Если ПараметрыОповещения = Неопределено Тогда
		ПараметрыОповещения = Новый Структура;
	КонецЕсли;
	Если НЕ Форма.НачальныйПризнакВыполнения И ВыполнитьЗадачу Тогда
		Если НЕ Форма.Записать(Новый Структура("ВыполнитьЗадачу", Истина)) Тогда
			Возврат Ложь;
		КонецЕсли;
		ТекстОповещения = НСтр("ru = 'Задача выполнена'");
	Иначе
		Если НЕ Форма.Записать() Тогда
			Возврат Ложь;
		КонецЕсли;
		ТекстОповещения = ?(НовыйОбъект, НСтр("ru = 'Задача создана'"), НСтр("ru = 'Задача изменена'"));
	КонецЕсли;
	
	Оповестить("Запись_ЗадачаИсполнителя", ПараметрыОповещения, Форма.Объект.Ссылка);
	ПоказатьОповещениеПользователя(ТекстОповещения,
		ПолучитьНавигационнуюСсылку(Форма.Объект.Ссылка),
		Строка(Форма.Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	Форма.Закрыть();
	Возврат Истина;
	
КонецФункции

// Открыть форму для ввода нового задания.
//
// Параметры:
//  ФормаВладелец  - УправляемаяФорма - форма, которая должна быть владельцем для открываемой.
//  ПараметрыФормы - Структура - параметры открываемой формы.
//
Процедура СоздатьЗадание(Знач ФормаВладелец = Неопределено, Знач ПараметрыФормы = Неопределено) Экспорт
	
	ОткрытьФорму("БизнесПроцесс.Задание.ФормаОбъекта", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры	

// Открыть форму для перенаправления одной или нескольких задач другому исполнителю.
//
// Параметры:
//  МассивЗадач  - Массив - список задач, которые необходимо перенаправить.
//  ВладелецФорма - УправляемаяФорма - форма, которая должна быть владельцем для открываемой
//                                     формы перенаправления задач.
//
Процедура ПеренаправитьЗадачи(МассивЗадач, ВладелецФорма) Экспорт

	Если МассивЗадач = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Не выбраны задачи.'"));
		Возврат;
	КонецЕсли;
		
	ЗадачиМогутБытьПеренаправлены = БизнесПроцессыИЗадачиВызовСервера.ПеренаправитьЗадачи(
		МассивЗадач, Неопределено, Истина);
	Если НЕ ЗадачиМогутБытьПеренаправлены И МассивЗадач.Количество() = 1 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Невозможно перенаправить уже выполненную задачу или направленную другому исполнителю.'"));
		Возврат;
	КонецЕсли;
		
	Оповещение = Новый ОписаниеОповещения("ПеренаправитьЗадачиЗавершение", ЭтотОбъект, МассивЗадач);
	ОткрытьФорму("Задача.ЗадачаИсполнителя.Форма.ПеренаправитьЗадачи",
		Новый Структура("Задача,КоличествоЗадач,ЗаголовокФормы", 
		МассивЗадач[0], МассивЗадач.Количество(), 
		?(МассивЗадач.Количество() > 1, НСтр("ru = 'Перенаправить задачи'"), 
			НСтр("ru = 'Перенаправить задачу'"))), 
		ВладелецФорма,,,,Оповещение);
		
КонецПроцедуры

// Открыть форму с дополнительной информацией о задаче.  
//
// Параметры:
//  ЗадачаСсылка       - ЗадачаИсполнителяСсылка  - задача.
//
Функция ОткрытьДопИнформациюОЗадаче(Знач ЗадачаСсылка) Экспорт
	
	ОткрытьФорму("Задача.ЗадачаИсполнителя.Форма.Дополнительно", 
		Новый Структура("Ключ", ЗадачаСсылка));
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьБизнесПроцесс(Список) Экспорт
	Если ТипЗнч(Список.ТекущаяСтрока) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	Если Список.ТекущиеДанные.БизнесПроцесс = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'У выбранной задачи не указан бизнес-процесс.'"));
		Возврат;
	КонецЕсли;
	ПоказатьЗначение(, Список.ТекущиеДанные.БизнесПроцесс);
КонецПроцедуры

Процедура ОткрытьПредметЗадачи(Список) Экспорт
	Если ТипЗнч(Список.ТекущаяСтрока) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	Если Список.ТекущиеДанные.Предмет = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'У выбранной задачи не указан предмет.'"));
		Возврат;
	КонецЕсли;
	ПоказатьЗначение(, Список.ТекущиеДанные.Предмет);
КонецПроцедуры

// Стандартный обработчик ПометкаУдаления для списков бизнес-процессов.
// Для вызова из обработчика события списка ПометкаУдаления.
//
// Параметры:
//   Список  - ТаблицаФормы - элемент управления (таблица формы) со списком бизнес-процессов.
//
Процедура СписокБизнесПроцессовПометкаУдаления(Список) Экспорт
	
	ВыделенныеСтроки = Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки = Неопределено ИЛИ ВыделенныеСтроки.Количество() <= 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	Оповещение = Новый ОписаниеОповещения("СписокБизнесПроцессовПометкаУдаленияЗавершение", ЭтотОбъект, Список);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Изменить пометку удаления?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

// Открывает форму выбора исполнителя.
//
// Параметры:
//   ЭлементИсполнитель - элемент формы, в которой выполняется выбора исполнителя, 
//      который будет указан как владелец формы выбора исполнителя.
//   РеквизитИсполнитель - выбранное ранее значение исполнителя.
//      Используется для установки текущей строки в форме выбора исполнителя.
//   ТолькоПростыеРоли - Булево, если Истина, то указывает что для выбора нужно 
//      использовать только роли без объектов адресации.
//   БезВнешнихРолей	- Булево, если Истина, то указывает, что для выбора надо
//      использовать только роли, у которых не установлен признак ВнешняяРоль.
//
Процедура ВыбратьИсполнителя(ЭлементИсполнитель, РеквизитИсполнитель, ТолькоПростыеРоли = Ложь, БезВнешнихРолей = Ложь) Экспорт 
	
	СтандартнаяОбработка = Истина;
	БизнесПроцессыИЗадачиКлиентПереопределяемый.ПриВыбореИсполнителя(ЭлементИсполнитель, РеквизитИсполнитель, 
		ТолькоПростыеРоли, БезВнешнихРолей, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
			
	ПараметрыФормы = Новый Структура("Исполнитель, ТолькоПростыеРоли, БезВнешнихРолей", 
		РеквизитИсполнитель, ТолькоПростыеРоли, БезВнешнихРолей);
	ОткрытьФорму("ОбщаяФорма.ВыборИсполнителяБизнесПроцесса", ПараметрыФормы, ЭлементИсполнитель);
	
КонецПроцедуры	

Процедура ОстановитьЗавершение(Знач Результат, Знач ПараметрКоманды) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;	
		
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		Если ПараметрКоманды.Количество() = 1 Тогда
			Состояние(НСтр("ru = 'Идет остановка бизнес-процесса. Пожалуйста подождите...'"));
		Иначе
			Состояние(НСтр("ru = 'Идет остановка бизнес-процессов. Пожалуйста подождите...'"));
		КонецЕсли;	
		
		БизнесПроцессыИЗадачиВызовСервера.ОстановитьБизнесПроцессы(ПараметрКоманды);
		
		Если ПараметрКоманды.Количество() = 1 Тогда
			Состояние(НСтр("ru = 'Бизнес-процесс остановлен.'"));
		Иначе	
			Состояние(НСтр("ru = 'Бизнес-процессы остановлены.'"));
		КонецЕсли;	
	Иначе	
		Состояние(НСтр("ru = 'Идет остановка бизнес-процесса. Пожалуйста подождите...'"));
		БизнесПроцессыИЗадачиВызовСервера.ОстановитьБизнесПроцесс(ПараметрКоманды);
		Состояние(НСтр("ru = 'Бизнес-процесс остановлен.'"));
	КонецЕсли;	
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		
		Если ПараметрКоманды.Количество() <> 0 Тогда
			
			Для Каждого Параметр Из ПараметрКоманды Цикл
				
				Если ТипЗнч(Параметр) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
					ОповеститьОбИзменении(ТипЗнч(Параметр));
					Прервать;
				КонецЕсли;	
				
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		ОповеститьОбИзменении(ПараметрКоманды);	
	КонецЕсли;	

КонецПроцедуры

Процедура СписокБизнесПроцессовПометкаУдаленияЗавершение(Результат, Список) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ВыделенныеСтроки = Список.ВыделенныеСтроки;
	БизнесПроцессСсылка = БизнесПроцессыИЗадачиВызовСервера.ПометитьНаУдалениеБизнесПроцессы(ВыделенныеСтроки);
	Список.Обновить();
	ПоказатьОповещениеПользователя(НСтр("ru = 'Пометка удаления изменена.'"), 
		?(БизнесПроцессСсылка <> Неопределено, ПолучитьНавигационнуюСсылку(БизнесПроцессСсылка), ""),
		?(БизнесПроцессСсылка <> Неопределено, Строка(БизнесПроцессСсылка), ""));
	
КонецПроцедуры

Процедура СделатьАктивнымЗавершение(Знач Результат, Знач ПараметрКоманды) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;	
		
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		
		Если ПараметрКоманды.Количество() = 1 Тогда
			Состояние(НСтр("ru = 'Бизнес-процесс и его задачи делаются активными. Пожалуйста подождите...'"));
		Иначе	
			Состояние(НСтр("ru = 'Бизнес-процессы и их задачи делаются активными. Пожалуйста подождите...'"));
		КонецЕсли;	
		
		БизнесПроцессыИЗадачиВызовСервера.СделатьАктивнымБизнесПроцессы(ПараметрКоманды);
		
		Если ПараметрКоманды.Количество() = 1 Тогда
			Состояние(НСтр("ru = 'Бизнес-процесс и его задачи сделаны активными.'"));
		Иначе	
			Состояние(НСтр("ru = 'Бизнес-процессы и их задачи сделаны активными.'"));
		КонецЕсли;	
		
	Иначе	
		Состояние(НСтр("ru = 'Идет отмена остановки бизнес-процесса. Пожалуйста подождите...'"));
		БизнесПроцессыИЗадачиВызовСервера.СделатьАктивнымБизнесПроцесс(ПараметрКоманды);
		Состояние(НСтр("ru = 'Бизнес-процесс и его задачи сделаны активными.'"));
	КонецЕсли;	
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		
		Если ПараметрКоманды.Количество() <> 0 Тогда
			
			Для Каждого Параметр Из ПараметрКоманды Цикл
				
				Если ТипЗнч(Параметр) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
					ОповеститьОбИзменении(ТипЗнч(Параметр));
					Прервать;
				КонецЕсли;	
				
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		ОповеститьОбИзменении(ПараметрКоманды);	
	КонецЕсли;	
		
КонецПроцедуры

Процедура ПеренаправитьЗадачиЗавершение(Знач Результат, Знач МассивЗадач) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если МассивЗадач.Количество() > 10 Тогда
		Состояние(НСтр("ru = 'Перенаправление задач'"),, 
			НСтр("ru = 'Выполняется перенаправление задач...'"));
	КонецЕсли;
	МассивПеренаправленныхЗадач = Неопределено;
	ЗадачиПеренаправлены = БизнесПроцессыИЗадачиВызовСервера.ПеренаправитьЗадачи(
		МассивЗадач, Результат, Ложь, МассивПеренаправленныхЗадач);
	Если МассивЗадач.Количество() > 1 Тогда
		Если ЗадачиПеренаправлены Тогда
			Состояние(НСтр("ru = 'Перенаправление задач'"),, 
				НСтр("ru = 'Задачи перенаправлены:'") + " " + МассивЗадач.Количество());
		Иначе
			Состояние(НСтр("ru = 'Перенаправление задач'"),,
				НСтр("ru = 'Не все задачи перенаправлены. Пропущены задачи, отмеченные как выполненные.'"));
		КонецЕсли;
	Иначе
		Задача = МассивПеренаправленныхЗадач[0];
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Задача перенаправлена'"),
			ПолучитьНавигационнуюСсылку(Задача),
			Строка(Задача));
	КонецЕсли;
	Оповестить("Запись_ЗадачаИсполнителя", Новый Структура("Перенаправлена", Истина), МассивЗадач);
	
КонецПроцедуры

#КонецОбласти
