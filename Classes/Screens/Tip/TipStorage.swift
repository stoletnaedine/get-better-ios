//
//  TipStorage.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 01.11.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct Tip {
    let title: String
    let text: String
}

enum TipStorage {
    
    static let tips: [Tip] = [
        Tip(title: "Ранний подъем",
            text: "Все успешные люди - пташки ранние. Что-то особенное и магическое есть в раннем подъеме. Эта часть дня, когда еще мир не проснулся, - самая важная и вдохновляющая. Те, кто встает до рассвета солнца, утверждают, что их жизнь стала полноценной. Попробуйте и вы вставать рано, и уже через месяц-другой вы будете с жалостью вспоминать те года, когда рассвет встречали в постели."),
        Tip(title: "Увлеченное чтение",
            text: "Если в день заменить час сидения перед телевизором или компьютером на чтение полезной и интересной книги, то вы станете самым умным человеком среди своего окружения. Вы будете быстрее находить ответы на вопросы, с вами будет интереснее общаться, многое будет получаться само собой. Как сказал Марк Твен: \"Человек, который не читает хороших книг, не имеет преимуществ перед человеком, который не умеет читать\"."),
        Tip(title: "Умение упрощать",
            text: "Упрощение - это устранение ненужного и бесполезного. Необходимо уметь упрощать все, что можно и нужно упростить. Хоть это и требует долгой практики, в итоге дает положительный результат. Очищаются память и чувства, вы меньше переживаете и нервничаете. Чем будет проще ваша жизнь, тем больше вы сможете ею наслаждаться."),
        Tip(title: "Замедление",
            text: "Наслаждаться жизнью в постоянном стрессе и хаосе невозможно. Найдите для себя тихое время, остановитесь, прислушайтесь к себе и своему внутреннему голосу. Обратите внимание на все, что имеет для вас значение. Возьмите за привычку просыпаться рано, когда вокруг тишина, чтобы медитировать, размышлять, созидать. Замедлите темп жизни, и тогда все, за чем вы гнались, само догонит вас."),
        Tip(title: "Тренируйтесь",
            text: "Регулярная активность сохраняет здоровье. Если у вас сейчас нет времени на тренировки, рано или поздно вы все равно начнете их делать, чтобы поддерживать свое здоровье. Спортом можно заниматься не только в тренажёрных залах, но и дома."),
        Tip(title: "Ежедневная практика",
            text: "Чем больше человек практикуется, тем удачливее он становится. Ведь удача - это то место, где практика встречается с возможностями. Без практики невозможно выразить свой талант. Практикуясь, вы всегда будете готовы воспользоваться возможностью показать свой талант."),
        Tip(title: "Окружение",
            text: "Именно эта привычка способна ускорить ваш успех. Окружите себя позитивными, энергичными людьми. Они - самая лучшая поддержка, мотивация и полезные советы. В часы депрессии общение со своими друзьями способно поднять вас на ноги."),
        Tip(title: "Заведите журнал благодарностей",
            text: "Это привычка, способная творить чудеса. Поблагодарите за все, что у вас есть, и стремитесь к лучшему. Благодарность способствует появлению новых поводов для радости. Перед сном записывайте по одной вещи, за которую вы благодарны. Чудеса не заставят себя ждать!"),
        Tip(title: "Будьте упорны",
            text: "Эдисон сделал 10000 неудачных попыток, прежде чем изобрести электрическую лампочку. Уолту Диснею для основания Диснейленда пришлось выслушать 303 отказа от различных банков, прежде чем он добился желаемого. 134 издателя отклонили книгу Дж. Кэнфилда и Марка В. Хансена “Куриный бульон для души”, прежде чем она стала мировым бестселлером. Чувствуете закономерность? Если вы хотите добиться желаемого, будьте упорны и не сдавайтесь!"),
        Tip(title: "Отпускайте людей и ситуации",
            text: "Не прокручивайте возможные варианты событий. Случилось так, как случилось. Когда сложно отпустить, задавайте два вопроса: \n«Будет ли это важно для меня через 5 лет?»,\n«Сегодня вечером я вылетаю в Сингапур (любое место, которое очень хотите посетить), возьму ли я эту проблему с собой?»"),
        Tip(title: "В конце каждой недели отвечайте на вопросы:",
            text: "«Что я изучил на прошлой неделе?»\n«Самое большое достижение за неделю?»\n«Какой момент на этой неделе был самым незабываемым и почему?»\n«Потратил ли я на что-то время впустую? Если да, то на что?»"),
        Tip(title: "Следите за внешностью",
            text: "Всегда будьте готовы к новым достижениям и неожиданным встречам. «Здравствуйте! В голове не укладывается… Мечтал о встрече с Вами всю жизнь! Ээээ… Только вы извините, сегодня я не очень хорошо выгляжу… Замотался, знаете ли…»"),
        Tip(title: "Не нойте и не жалуйтесь на судьбу",
            text: "Молча встаньте, идите и делайте всё, что необходимо."),
        Tip(title: "Путешествуйте",
            text: "Два раза в год отправляйтесь туда, где никогда не были. Путешествия помогут обрести себя."),
        Tip(title: "Позвольте себе делать ошибки",
            text: "Что-то упустили – не упустите урок из этого. Ошибка – отличная возможность для развития."),
        Tip(title: "Развивайте индивидуальность",
            text: "Вы такие, какие есть. Ни с кем не соревнуетесь, кроме себя."),
        Tip(title: "Принимайте решения самостоятельно",
            text: "Не готовьте по чужим рецептам."),
        Tip(title: "Не навязывайтесь",
            text: "Мир огромен – в нём точно есть тот, кто будет счастлив, получая именно Ваши взгляд и улыбку."),
        Tip(title: "Медитируйте каждый день",
         text: "Учитесь расслабляться и концентрироваться."),
        Tip(title: "Улыбайтесь, если что-то вышло не так, как вы планировали",
            text: "Помните, не получить желаемое – иногда и есть везение."),
        Tip(title: "Учись говорить «НЕТ»",
            text: "Не бойтесь отказывать!\n– Не желаете ли совершить визит вежливости? Нет?\n– Нет!"),
        Tip(title: "Оценивайте свои слова",
            text: "Оценивайте каждое произносимое слово на правдивость, полезность и доброту. Говорите по сути, ничего лишнего. НЕТ – сплетням, лжи и жалобам! Лучше молчите, если нечего сказать."),
        Tip(title: "Думайте",
            text: "Прежде, чем принять решение, оцените его стоимость."),
        Tip(title: "24 часа",
            text: "Если Вас угораздило сильно разозлиться на кого-то – подождите 24 часа прежде, чем ответить."),
        Tip(title: "Будьте независимы и самодостаточны",
            text: "Ваше счастье зависит только от Вас, а не от того, как думают и поступают другие люди."),
        Tip(title: "Уважайте себя и других",
            text: "Человек выбирает сам. Не вмешивайтесь в дела, которые Вас не касаются. Не заглядывайте в чужую жизнь мыслями и словами – не упускайте из вида Свой выбор!"),
        Tip(title: "Действуйте исключительно внутри собственной сферы влияния",
            text: "Не беспокойтесь о том, на что не можете влиять."),
        Tip(title: "Бывайте на свежем воздухе каждый день",
            text: "Вне зависимости от погоды и настроения."),
        Tip(title: "Верьте в мечты и идеи",
            text: "Время нелинейно. Они уже осуществились!"),
        Tip(title: "Развивайте таланты",
            text: "Помните, они у Вас есть! Просто откройте глаза."),
        Tip(title: "Будьте ответственны за свои слова и поступки",
            text: "Ваши слова имеют огромную силу."),
        Tip(title: "Будьте верным",
            text: "Людям, принципам и выбору.\n«Быть верным – не врождённое качество. Это решение!»"),
        Tip(title: "Делай сразу",
            text: "Если есть дело, работа над которым займёт меньше 3-х минут, – его следует выполнить незамедлительно. Не откладывайте в доооолгий ящик. Туда давно уже ничего не помещается."),
        Tip(title: "Следите за здоровьем",
            text: "Оно – одно. Впереди у Вас свершения – здоровье понадобится для их реализации. Спорт, йога, медитация помогут. Проверьте!"),
        Tip(title: "Обретите внутренний покой и гармонию",
            text: "Истинная сила человека проявляется не в порывах, а в спокойствии."),
        Tip(title: "Примите факт, что прошлое в прошлом",
            text: "Его не существует! Извлекайте опыт, отпустите и идите дальше."),
        Tip(title: "Расставляйте приоритеты",
            text: "Всему своё место."),
        Tip(title: "Побеждайте страхи",
            text: "Страх – всего лишь иллюзия."),
        Tip(title: "Никогда не сдавайтесь!",
            text: "Настойчивость и упорство всегда вознаграждаются."),
        Tip(title: "Принцип зеркала",
            text: "Перед тем как осудить другого человека, обратите сначала внимание на себя. Это про соринку в чужом глазу. Все мы не идеальны."),
        Tip(title: "Принцип бумеранга",
            text: "Помогая другим, вы помогаете себе. Все и всегда сделанное вами, вернется к вам обратно, в нужное время, в нужном месте и от нужных людей."),
        Tip(title: "Принцип боли",
            text: "Вы наносите обиды другим, когда обижены сами. А когда сердце наполнено любовью, желание обижать других пропадает само собой."),
        Tip(title: "Принцип молотка",
            text: "Не надо использовать молоток, чтобы убить маленького комара на лбу собеседника. Будьте тактичны и не говорите того, о чем можете потом пожалеть."),
        Tip(title: "Принцип верхней дороги",
            text: "Когда мы начинаем обращаться с другими людьми лучше, чем они обращаются с нами, мы переходим на более высокий уровень развития. Поднимаясь все выше и выше, не опускайтесь до сплетен, критики и осуждения."),
        Tip(title: "Принцип харизмы",
            text: "Искренне интересуйтесь людьми, ведь мы, чаще всего, проявляем интерес к тому человеку, который интересуется нами."),
        Tip(title: "Принцип обмена",
            text: "Не ставьте людей на «их место», научитесь СЕБЯ ставить на их место. Тогда вы будете реже судить и больше понимать."),
        Tip(title: "Принцип 100 баллов",
            text: "Когда вы видите в человеке больше положительного, чем отрицательного и верите в его лучше качества, вы «заставляете» его проявлять их."),
        Tip(title: "Принцип обучения",
            text: "Каждый человек в нашей жизни – это наш учитель, который потенциально способен нас чему-то научить."),
        Tip(title: "Принцип каменной скалы",
            text: "Крепкий фундамент любых взаимоотношений – это доверие. Старайтесь доверять людям и не предавать людей, которые доверяют вам."),
        Tip(title: "Принцип конфронтации",
            text: "Прежде чем вступить с человеком в конфронтацию, позаботьтесь о нем."),
        Tip(title: "Принцип Боба",
            text: "Если у Боба проблемы со всеми, то главной проблемой, чаще всего, является он сам."),
        Tip(title: "Принцип лифта",
            text: "Общаясь с людьми, мы либо поднимаем их вверх, либо опускаем вниз. Всегда помните об этом и старайтесь поднять человека, а не опустить."),
        Tip(title: "Принцип доступности",
            text: "Когда человеку легко с самим собой, другие тоже чувствуют себя легко и свободно с ним. Отношения с самим собой отражает отношение к нам других людей. Также советую почитать статью “Волшебная энергия любви к себе”."),
        Tip(title: "Принцип окопа",
            text: "Если вы готовитесь к сражению, выкопайте такой окоп, в котором поместитесь не только вы, но и ваш друг."),
        Tip(title: "Принцип 101 процента",
            text: "Отыщите 1 процент, с которым вы согласны и направьте на него 100 процентов усилий."),
        Tip(title: "Принцип терпения",
            text: "Всегда помните, что путешествовать с другими приходится медленнее, чем одному."),
        Tip(title: "Принцип празднования",
            text: "Настоящая проверка дружбы заключается не в том, насколько мы подставляем свое плечо своим друзьям, когда у них проблемы, а в том, насколько мы радуемся их успехам."),
        Tip(title: "Принцип дружбы",
            text: "Как при прочих равных условиях, так и при неравных, люди всегда будут стремиться работать с теми, кто им нравится."),
        Tip(title: "Принцип удовлетворения",
            text: "В прекрасных взаимоотношениях обеим сторонам для получения радости и удовольствия достаточно просто находиться вместе.")
    ]
}
