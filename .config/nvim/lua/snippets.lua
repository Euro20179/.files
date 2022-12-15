local ls = require('luasnip')
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("sh", {
    ls.s("printf", {
	ls.t("printf \""),
	ls.i(1, "%s\\n"),
	ls.t("\" \""),
	ls.i(2, "text"),
	ls.t("\""),
	ls.i(0)
    })
})

ls.add_snippets("nroff", {
    ls.s("fb", {
	ls.t("\\fB"),
	ls.i(1, "{text}"),
	ls.t("\\fR"),
	ls.i(0, "")
    }),
    ls.s("fi", {
	ls.t("\\fI"),
	ls.i(1, "{text}"),
	ls.t("\\fR"),
	ls.i(0, "")
    }),
    ls.s("b", {
	ls.t(".B "),
	ls.i(1, "{text}"),
	ls.i(0)
    }),
    ls.s("i", {
	ls.t(".I "),
	ls.i(1, "{text}"),
	ls.i(0)
    })
})

ls.add_snippets("text", {
    ls.s("tcsr",
    fmt([[My student's engagement is {engagement}.
My student needs {goal}.
{feelings}.
]], {
        engagement = ls.c(1, {ls.t("reserved/shy"), ls.t("talkative"), ls.t("excited"), ls.t("high energy"), ls.t("unfocused")}),
        goal = ls.c(2, {
            ls.sn(nil, {
                ls.i(1),
                ls.t("to start a "),
                ls.i(2, "[language]"),
                ls.t(" "),
                ls.c(3, {ls.t"beginner", ls.t"intermediate", ls.t"advanced"})
            }),
            ls.sn(nil, {
                ls.i(1),
                ls.t("objectives for "),
                ls.i(2, "[language]"),
                ls.t" ",
                ls.c(3, {ls.t"beginner", ls.t"intermediate", ls.t"advanced"}),
                ls.t(" project")
            }),
            ls.t("to build interest in a project"),
            ls.t("Is interested & progressing well")
        }),
        feelings = ls.sn(3, {
            ls.t("I "),
            ls.c(1, {
                ls.t"do feel I'm a good coach for the student",
                ls.sn(nil, {
                    ls.i(1),
                    ls.t("do not feel I'm a good coach for the student."),
                    ls.i(2, "put a new line here"),
                    ls.t("I need "),
                    ls.i(3, "[insert what]"),
                    ls.t(" help with getting the student interested in the project")
                })
            })
        })
    }))
})

ls.add_snippets("text", {
    ls.s("tcs",
	fmt([[{student} was {interest} to use {concept} and {added} {stuffAdded} {project}. I was really {pleased} to see how they took {concept2} and {coded_it}
Homework:
It would be great if {student2} can {next_step} as they build out their project.
Login:
website: {website}
email: {email}
username: {username}
password: {password}
To get to where we left off, {steps}]], {
	    student = ls.i(1, "[Student]"),
	    interest = ls.c(2, { ls.t("excited"), ls.t("looking forward"), ls.t("eager"), ls.t("interested"), ls.t("inquisitive") }),
	    concept = ls.i(3, "[coding concept practiced]"),
	    added = ls.c(4, { ls.t("added"), ls.t("continue to build on"), ls.t("built momentum with") }),
	    stuffAdded = ls.i(5, "[Stuff]"),
        project = ls.i(6, "to their project today"),
	    pleased = ls.c(7, { ls.t("pleased"), ls.t("thrilled"), ls.t("excited"), ls.t("happy") }),
	    concept2 = ls.i(8, "[coding concept practiced]"),
	    coded_it = ls.i(9, "[Insert how they coded it]"),
	    student2 = ls.i(10, "[Student]"),
	    next_step = ls.i(11, "[next step]"),
	    website = ls.i(12, "[Website]"),
	    email = ls.i(13, "[Email]"),
	    username = ls.i(14, "[Username]"),
	    password = ls.i(15, "[Password]"),
	    steps = ls.i(16, "[Get to where we left off]")
	})
    ),
})
