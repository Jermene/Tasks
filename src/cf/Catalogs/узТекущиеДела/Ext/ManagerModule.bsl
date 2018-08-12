﻿Процедура ДобавитьЗадачуВТекущиеДела(ДопПараметры) Экспорт
	пАвтор = ДопПараметры.Автор;
	МассивЗадач = ДопПараметры.МассивЗадач;
	Для каждого пЗадача из МассивЗадач цикл
		СпрОбъект = СоздатьТекДелоПоОбъекту(пЗадача,пАвтор);
	Конеццикла;	
КонецПроцедуры

Функция СоздатьТекДелоПоОбъекту(ОбъектТекущихДел,пАвтор) 
	ТипЗнчОбъектТекущихДел = ТипЗнч(ОбъектТекущихДел); 
	ЭтоЗадача = ТипЗнчОбъектТекущихДел = Тип("СправочникСсылка.узЗадачи");
	ЭтоВопрос = ТипЗнчОбъектТекущихДел = Тип("СправочникСсылка.узВопросыОтветы");
	Если НЕ ЭтоЗадача
		И НЕ ЭтоВопрос Тогда
		ВызватьИсключение "Ошибка! Нет алгоритма для ОбъектТекущихДел ["+ОбъектТекущихДел+"]";
	Конецесли;
	
	Если ЭтоЗадача Тогда
		пНомерЗадачи = Справочники.узЗадачи.ПолучитьНомерЗадачи(ОбъектТекущихДел);
		пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Выполнить задачу #%1 %2",78);
		пТекстСообщения = СтрШаблон(пТекстСообщения,пНомерЗадачи,ОбъектТекущихДел);
	ИначеЕсли ЭтоВопрос Тогда
		пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Вопрос: %1",87);
		пТекстСообщения = СтрШаблон(пТекстСообщения,ОбъектТекущихДел);		
	Конецесли;
	
		
	СпрОбъект = Справочники.узТекущиеДела.СоздатьЭлемент();
	СпрОбъект.Автор = пАвтор;
	Если ЭтоЗадача Тогда
		СпрОбъект.Задача = ОбъектТекущихДел;
	ИначеЕсли ЭтоВопрос Тогда		
		СпрОбъект.Вопрос = ОбъектТекущихДел;	
		СпрОбъект.Задача = СпрОбъект.Вопрос.Задача;
	Конецесли;
	
	СпрОбъект.ТекстСодержания = пТекстСообщения;
	СпрОбъект.Наименование = СпрОбъект.ТекстСодержания;
	СпрОбъект.ДатаСоздания = ТекущаяДата();	
	СпрОбъект.ДатаТекущегоДела = СпрОбъект.ДатаСоздания; 
	СпрОбъект.Порядок = 1000;
	СпрОбъект.Записать();
	
	пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Добавлено дело",80);	
	пТекстСообщения = пТекстСообщения + " "+ СпрОбъект.ТекстСодержания;
	
	Сообщить(пТекстСообщения);
	Возврат СпрОбъект;
КонецФункции 

Процедура ДобавитьВопросВТекущиеДела(ДопПараметры) Экспорт
	пАвтор = ДопПараметры.Автор;
	МассивВопросов = ДопПараметры.МассивВопросов;
	Для каждого пВопрос из МассивВопросов цикл
		СпрОбъект = СоздатьТекДелоПоОбъекту(пВопрос,пАвтор);
	Конеццикла;	
КонецПроцедуры 

Функция ПолучитьПорядоДоп(пВыполнено,пДатаВыполнения,пНаДату) Экспорт
	пПорядокДоп = 0;
	Возврат пПорядокДоп;
	//пПорядокДоп = 10;
	//Если НЕ пВыполнено Тогда
	//	пПорядокДоп = 0;
	//Иначе
	//	Если НачалоДня(пДатаВыполнения) <> пНаДату Тогда
	//		пПорядокДоп = 1;
	//	Иначе
	//		пПорядокДоп = 2;
	//	Конецесли;
	//Конецесли;
	//Возврат пПорядокДоп;	
КонецФункции