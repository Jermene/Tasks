﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ НАСТРОЙКИ ПОРЯДКА ЭЛЕМЕНТОВ
&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
    НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(Список, Элементы.Список);
КонецПроцедуры    
&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)	
    НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(Список, Элементы.Список);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Поддержка группового изменения объектов.

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список, Список);	
КонецПроцедуры

&НаКлиенте
Процедура НаблюдательПриИзменении(Элемент)
	УстановитьПараметрыСписка();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СкрыватьЗадачиСОпределеннымСтатусом = Истина;
	УстановитьВидимостьДоступность();
	УстановитьПараметрыСписка();
	ВыполнитьЛокализацию();
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЛокализацию()
	МассивКодовСообщений = Новый Массив();
	МассивКодовСообщений.Добавить(70);//Наблюдатель
	
	РегистрыСведений.узСловарь.ВыполнитьЛокализацию(Элементы,МассивКодовСообщений);
КонецПроцедуры //ВыполнитьЛокализацию()

&НаСервере
Процедура УстановитьПараметрыСписка()
	Список.Параметры.УстановитьЗначениеПараметра("ИспользоватьОтборПоНаблюдателю",ЗначениеЗаполнено(Наблюдатель));	
	Список.Параметры.УстановитьЗначениеПараметра("Наблюдатель",Наблюдатель);
	Список.Параметры.УстановитьЗначениеПараметра("СкрыватьЗадачиСОпределеннымСтатусом",СкрыватьЗадачиСОпределеннымСтатусом);
	Список.Параметры.УстановитьЗначениеПараметра("ИспользоватьОтборПоНомеруЗадачи",ЗначениеЗаполнено(НомерЗадачи));	
	Список.Параметры.УстановитьЗначениеПараметра("НомерЗадачи",НомерЗадачи);	
	
	// _Демо начало примера
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователи.АвторизованныйПользователь());
	// _Демо конец примера	
КонецПроцедуры //УстановитьПараметрыСписка

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Элементы.ЕстьЗаметки.Видимость = Ложь;
	пИспользоватьЗаметки = Константы.ИспользоватьЗаметки.Получить(); 
	Если пИспользоватьЗаметки Тогда
		Элементы.ЕстьЗаметки.Видимость = Истина;
	Конецесли;
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьСкрытьЗадачи(Команда)
	СкрыватьЗадачиСОпределеннымСтатусом = НЕ СкрыватьЗадачиСОпределеннымСтатусом;
	УстановитьПараметрыСписка();
КонецПроцедуры

&НаКлиенте
Процедура НомерЗадачиПриИзменении(Элемент)
	Если ЗначениеЗаполнено(НомерЗадачи) Тогда
		СкрыватьЗадачиСОпределеннымСтатусом = Ложь;
		Если Элементы.Список.Отображение <> ОтображениеТаблицы.Список Тогда
			Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		Конецесли;
	Иначе
		СкрыватьЗадачиСОпределеннымСтатусом = Истина;
	Конецесли;
	УстановитьПараметрыСписка();
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	// СтандартныеПодсистемы.Взаимодействие
	узОбщийМодульКлиент.СписокПредметПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);	
	// Конец СтандартныеПодсистемы.Взаимодействие
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	// СтандартныеПодсистемы.Взаимодействие
	узОбщийМодульКлиент.СписокПредметПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);
	// Конец СтандартныеПодсистемы.Взаимодействие
	
КонецПроцедуры
