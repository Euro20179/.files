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


ls.add_snippets("email", {
    ls.s("email",
        fmt([[> from: {from}
> to: {to}
> subject: {subject}
> cc: {cc}
> bcc: {bcc}
> format: {format}
> body: {body}]], {
    from = ls.i(1, "[from]"),
    to = ls.i(2, "[to (comma seperated)]"),
    subject = ls.i(3, "[subject]"),
    cc = ls.i(4, "[cc (comma separated)]"),
    bcc = ls.i(5, "[bcc (comma separated)]"),
    format = ls.c(6, {ls.t("html"), ls.t("text")}),
    body = ls.i(7, "[body]")
})
    )
})


