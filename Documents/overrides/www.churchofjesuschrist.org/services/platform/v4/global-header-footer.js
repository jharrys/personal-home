parcelRequire = function(e) {
    var r = "function" == typeof parcelRequire && parcelRequire
      , n = "function" == typeof require && require
      , i = {};
    function u(e, u) {
        if (e in i)
            return i[e];
        var t = "function" == typeof parcelRequire && parcelRequire;
        if (!u && t)
            return t(e, !0);
        if (r)
            return r(e, !0);
        if (n && "string" == typeof e)
            return n(e);
        var o = new Error("Cannot find module '" + e + "'");
        throw o.code = "MODULE_NOT_FOUND",
        o
    }
    return u.register = function(e, r) {
        i[e] = r
    }
    ,
    i = e(u),
    u.modules = i,
    u
}(function(require) {
    function ca(e, o) {
        var r = Object.keys(e);
        if (Object.getOwnPropertySymbols) {
            var t = Object.getOwnPropertySymbols(e);
            o && (t = t.filter(function(o) {
                return Object.getOwnPropertyDescriptor(e, o).enumerable
            })),
            r.push.apply(r, t)
        }
        return r
    }
    function D(e) {
        for (var o = 1; o < arguments.length; o++) {
            var r = null != arguments[o] ? arguments[o] : {};
            o % 2 ? ca(Object(r), !0).forEach(function(o) {
                oa(e, o, r[o])
            }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(r)) : ca(Object(r)).forEach(function(o) {
                Object.defineProperty(e, o, Object.getOwnPropertyDescriptor(r, o))
            })
        }
        return e
    }
    function oa(e, o, r) {
        return o in e ? Object.defineProperty(e, o, {
            value: r,
            enumerable: !0,
            configurable: !0,
            writable: !0
        }) : e[o] = r,
        e
    }
    var Y = e=>{
        const t = document.querySelector("platform-header").shadowRoot;
        return [t.querySelectorAll(".topNavItem"), t.querySelectorAll(".subNavItem"), t.querySelectorAll(".topItem"), t.querySelectorAll(".subNavItem"), t.querySelectorAll(".cucNavItem"), t.querySelectorAll("platform-nav-item")]
    }
    ;
    const J = {
        setActive(e) {
            e.setAttribute("active", !0)
        },
        removeActive(e) {
            e.removeAttribute("active")
        },
        toggleActive(e) {
            e.hasAttribute("active") ? this.removeActive(e) : this.setActive(e)
        },
        clearActiveItems(e, t) {
            (e || []).forEach(e=>Array.prototype.map.call(e || [], e=>{
                t !== e && (this.removeActive(e),
                e.classList.remove("wasClicked"))
            }
            ))
        },
        clearSubNav() {
            const e = document.querySelector(".subNavMenu");
            e && (e.style.display = "none")
        },
        clearControlPanel(e) {
            let t = e.target.parentNode;
            Array.prototype.map.call(controlPanel && controlPanel.children, e=>{
                t === e ? this.toggleActive(t) : this.removeActive(e)
            }
            )
        },
        clearAll(e, t) {
            if (this.clearActiveItems(Y() || [], e),
            this.clearSubNav(),
            !0 !== t) {
                const e = document.getElementById("prefBoxLinks");
                this.clearActiveItems([e && e.children])
            }
        }
    };
    function da(e, t) {
        var i = Object.keys(e);
        if (Object.getOwnPropertySymbols) {
            var n = Object.getOwnPropertySymbols(e);
            t && (n = n.filter(function(t) {
                return Object.getOwnPropertyDescriptor(e, t).enumerable
            })),
            i.push.apply(i, n)
        }
        return i
    }
    function pa(e) {
        for (var t = 1; t < arguments.length; t++) {
            var i = null != arguments[t] ? arguments[t] : {};
            t % 2 ? da(Object(i), !0).forEach(function(t) {
                qa(e, t, i[t])
            }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(i)) : da(Object(i)).forEach(function(t) {
                Object.defineProperty(e, t, Object.getOwnPropertyDescriptor(i, t))
            })
        }
        return e
    }
    function qa(e, t, i) {
        return t in e ? Object.defineProperty(e, t, {
            value: i,
            enumerable: !0,
            configurable: !0,
            writable: !0
        }) : e[t] = i,
        e
    }
    var ra = handleNavAnalytics = e=>{
        window.digitalDataEvents.component || (window.digitalDataEvents = pa({
            component: {
                siteNavigation: "Site Navigation"
            }
        }, window.digitalDataEvents));
        const t = e=>{
            var t, i, n, r, o;
            const a = (null == e ? void 0 : null === (t = e.target) || void 0 === t ? void 0 : t.ariaLabel) || (null == e ? void 0 : null === (i = e.explicitOriginalTarget) || void 0 === i ? void 0 : i.nodeValue)
              , l = null == e ? void 0 : null === (n = e.target) || void 0 === n ? void 0 : null === (r = n.attributes) || void 0 === r ? void 0 : null === (o = r.href) || void 0 === o ? void 0 : o.value
              , d = e.target.className.includes("cojc")
              , c = e.target.accessKey;
            a && d && window.digitalData.push({
                event: window.digitalDataEvents.component.siteNavigation,
                component: {
                    category: {
                        primary: "Navigation"
                    },
                    info: {
                        location: window.innerWidth < 841 ? "Main Hamburger" : "Main Header",
                        menuItem: null == a ? void 0 : a.replace(/\./g, ""),
                        menu: c,
                        href: l
                    }
                },
                user: {
                    profile: {
                        info: {
                            loginStatus: window.PFdataLayer.info.loginStatus
                        }
                    }
                }
            })
        }
        ;
        e.addEventListener("mouseup", e=>{
            e.stopPropagation(),
            t(e)
        }
        , !0),
        e.addEventListener("keydown", e=>{
            13 === (e.which || e.keyCode) && t(e)
        }
        )
    }
    ;
    const sa = (t,e)=>t.sections.map(t=>`<div class="navSection" ${t.ref ? "data-ref=\"" + t.ref + "\"" : ""}>\n\t\t\t\t${void 0 !== t.title ? `<span class="sectionHead" aria-label="${t.title}.">${t.title}</span>` : ""}\n\t\t\t\t<ul>\n\t\t\t\t\t${t.links && t.links.map(t=>`<li class="navLink" id="${t.title.toLowerCase().replace(/\s/g, "-")}-li">\n\t\t\t\t\t\t\t<a accessKey="${e}" class="cojc" href="${t.href}" id="${t.title.toLowerCase().replace(/\s/g, "-")}-a" aria-label="${t.title}.">\n\t\t\t\t\t\t\t\t${t.title}\n\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t</li>`).join("")}\n\t\t\t\t</ul>\n\t\t\t</div>`).join("")
      , ta = (t,e,i,s,a)=>{
        let r = "";
        return r = t.sections ? `<span class="navTitle" id="${t.title.toLowerCase().replace(/\s/g, "-")}-span" aria-label="${t.title}.">${t.title}</span>\n\t\t<span class="navArrow" aria-hidden="true"></span>\n\t\t<div id=${0 === e ? "nav-first-item" : e === i - 1 ? "nav-last-item" : `nav-item=${e}`} class="menuBox">\n\t\t\t${sa(t, a)}\n\t\t</div>` : t.items ? `<span class="navTitle" id="${t.title.toLowerCase().replace(/\s/g, "-")}-span" aria-label="${t.title}.">${t.title}</span>\n\t\t<span class="navArrow" aria-hidden="true"></span>\n\t\t<div id=${0 === e ? "nav-first-item" : e === i - 1 ? "nav-last-item" : `nav-item=${e}`} class="menuBox">\n\t\t\t<div class="navSection">\n\t\t\t\t<ul>\n\t\t\t\t${t.items.map(t=>{
            let {href: e, title: i} = t;
            return `<li class="navLink" aria-label="${i}." id="${i.toLowerCase().replace(/\s/g, "-")}-li">\n\t\t\t\t\t\t<a href="${e}" id="${i.toLowerCase().replace(/\s/g, "-")}-a">${i}</a>\n\t\t\t\t\t</li>`
        }
        ).join("")}\n\t\t\t\t</ul>\n\t\t\t</div>\n\t\t</div>` : `<a class="navLink simpleLink" id="${t.title.toLowerCase().replace(/\s/g, "-")}-a"aria-label="${t.title}." href=${t.href}>${t.title}</a>`,
        `<li class=${s + "NavItem"} tabIndex=${t.items || t.sections ? 0 : -1} ${"sub" === s ? "aria-owns=\"subMenuBox\"" : ""}>${r}`
    }
    ;
    class ea extends HTMLElement {
        get header() {
            return document.querySelector("platform-header").shadowRoot
        }
        get subNavMenu() {
            return this.header.querySelector("header").querySelector(".subNavMenu")
        }
        get collections() {
            return [this.header.querySelectorAll(".topNavItem"), this.header.querySelectorAll(".subNavItem"), this.header.querySelectorAll(".topItem"), this.header.querySelectorAll(".subNavItem"), this.header.querySelectorAll("platform-nav-item")]
        }
        get navContainer() {
            return this.header.querySelector("#PFnavContainer")
        }
        get mobileBreadcrumb() {
            return this.header.querySelector("#PFmobileBreadcrumb")
        }
        get isComeUntoChrist() {
            var t, e, i;
            return null === (t = window) || void 0 === t ? void 0 : null === (e = t.platformConfig) || void 0 === e ? void 0 : null === (i = e.headerConfig) || void 0 === i ? void 0 : i.isComeUntoChrist
        }
        get active() {
            return this.hasAttribute("active")
        }
        set active(t) {
            t ? (this.setAttribute("active", !0),
            this.firstChild.setAttribute("active", !0)) : (this.removeAttribute("active"),
            this.firstChild.removeAttribute("active"))
        }
        static get observedAttributes() {
            return ["active"]
        }
        constructor() {
            super(),
            this.addEventListener("mouseup", t=>{
                t.stopPropagation(),
                this.toggleMenu(t.target),
                this.firstElementChild.classList.add("wasClicked"),
                !(document.body.clientWidth < 841 || this.isComeUntoChrist) || t.target.classList.contains("simpleLink") || t.target.classList.contains("subNavItem") || t.target.classList.contains("cucNavItem") || (this.navContainer.setAttribute("data-breadcrumbs", !0),
                this.mobileBreadcrumb.innerText = this.innerText.split("\n")[0])
            }
            , !0),
            this.addEventListener("keydown", t=>{
                switch (t.which || t.keyCode) {
                case 13:
                case 32:
                    this.toggleMenu(t.target);
                }
            }
            )
        }
        connectedCallback() {
            ra(this),
            this.firstElementChild.addEventListener("keydown", t=>{
                const e = this.header.activeElement
                  , i = t.which || t.keyCode;
                if (9 === i && e.classList.contains("subNavItem"))
                    if (this.active)
                        t.preventDefault(),
                        this.handleTab();
                    else {
                        if (!t.shiftKey || 9 !== i || e.classList.contains("subNavItem"))
                            return;
                        t.preventDefault(),
                        this.handleShiftTab()
                    }
            }
            )
        }
        handleTab() {
            const t = this.subNavMenu.querySelector(".navLink");
            t && t.firstElementChild.focus(),
            t.addEventListener("keydown", t=>{
                t.shiftKey && 9 === t.keyCode && (t.preventDefault(),
                this.handleShiftTab())
            }
            )
        }
        handleShiftTab() {
            const t = this.subNavMenu.querySelector(".navLink");
            this.firstElementChild.focus(),
            t.removeEventListener("keydown", this.handleShiftTab)
        }
        attributeChangedCallback() {
            if (this.firstChild.classList.value.includes("subNavItem"))
                if (this.active) {
                    if (this.firstChild.querySelector("div")) {
                        const t = this.getBoundingClientRect()
                          , e = window.pageYOffset
                          , i = {
                            height: 10,
                            width: 6.5
                        }
                          , s = this.firstChild.querySelector("div").firstElementChild.cloneNode(!0)
                          , a = this.subNavMenu;
                        a.children.length ? a.replaceChild(s, a.firstChild) : a.appendChild(s),
                        a.setAttribute("style", `top: ${t.bottom + e}px;\n\t\t\t\t\t\tleft: ${t.left > 16 ? t.left : 16}px;\n\t\t\t\t\t\tdisplay: flex;`);
                        const r = a.getBoundingClientRect().right > this.navContainer.clientWidth;
                        r && a.setAttribute("style", `top: ${t.bottom + e}px;\n\t\t\t\t\t\t\tleft: auto;\n\t\t\t\t\t\t\tright: 1rem;\n\t\t\t\t\t\t\tdisplay: flex;`),
                        r ? (a.style.setProperty("--arrowSpacingRight", `${t.width / 2 - i.width - 16}px`),
                        a.style.setProperty("--arrowSpacingLeft", "auto")) : (a.style.setProperty("--arrowSpacingLeft", `${t.width / 2 - i.width - 16}px`),
                        a.style.setProperty("--arrowSpacingRight", "auto"))
                    }
                } else
                    this.subNavMenu.style.display = "none"
        }
        toggleMenu(t) {
            t.hasAttribute("active") ? (this.removeAttribute("active"),
            t.removeAttribute("active")) : (J.clearActiveItems(Y(), t),
            this.setAttribute("active", !0),
            t.setAttribute("active", !0))
        }
        addMenuItem(t, e, i, s, a) {
            this.innerHTML = ta(t, e, i, s, a)
        }
    }
    window.customElements.define("platform-nav-item", ea);
    const K = ()=>window.platformConfig && window.platformConfig.searchConfig ? window.platformConfig.searchConfig : void 0;
    const fa = ()=>window.platformConfig && window.platformConfig.headerConfig ? window.platformConfig.headerConfig : void 0;
    const ua = t=>t.sections.map(t=>`<div class="navSection" ${t.ref ? "data-ref=\"" + t.ref + "\"" : ""}>\n\t\t\t\t${void 0 !== t.title ? `<span class="sectionHead" aria-label="${t.title}.">${t.title}</span>` : ""}\n\t\t\t\t<ul>\n\t\t\t\t\t${t.links && t.links.map(t=>`<li class="navLink">\n\t\t\t\t\t\t\t<a href="${t.href}" aria-label="${t.title}.">\n\t\t\t\t\t\t\t\t${t.title}\n\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t</li>`).join("")}\n\t\t\t\t</ul>\n\t\t\t</div>`).join("")
      , va = t=>t.sections.map(t=>{
        let e = t.title.replace(/\s/g, "").toLocaleLowerCase().replace(/([()])/g, "")
          , n = (t.links || []).map((t,e)=>{
            let n = (t.title || "").replace(/\s/g, "");
            return `<a class="PFbutton secondary-button small pref-button" href="${t.href}" aria-label="${n}.">\n\t\t\t\t\t\t\t<span class="platformIcon ${n}" id=${0 === e ? "PFregionIcon" : "PFlangIcon"}></span>\n\t\t\t\t\t\t\t\t${t.title || ""}\n\t\t\t\t\t\t</a>`
        }
        ).join("");
        return `<div class="buttonSection" ${t.ref ? "data-ref=\"" + t.ref + "\"" : ""}>\n\t\t\t\t\t<span class="platformIcon-${e}"></span>\n\t\t\t\t\t${n}\n\t\t\t\t</div>`
    }
    ).join("")
      , Z = (t,e,n,a)=>{
        const {signInServiceUrl: i, signOutServiceUrl: o} = t;
        let s = "in" === e ? LDSprops.setURL("signin", i) : LDSprops.setURL("signout", o);
        return `<a tabindex="0"\tclass="PFbutton ${"in" === e ? "primary-button" : "ghost-button"} small PFloginButton" id="${"in" === e ? "loginButtonDisplay" : "logoutButtonDisplay"}" onclick="window.location.replace( '${s}' )" onkeydown="if(event.which === 13 || event.keyCode === 13) (window.location.replace( '${s}' ))()"\n\t>\n\t\t${"in" === e ? n : a}\n\t</a>`
    }
      , wa = (t,e,n)=>{
        const {title: a, signIn: i, signOut: o} = t;
        return `<li style="display: none;" tabindex="0" class="topItem${"maw" === e ? " accountLink" : ""}">\n\t\t<span class="iconLink" id=${e + "Icon"}>\n\t\t\t<span class="iconLinkTitle">\n\t\t\t\t${a || ""}\n\t\t\t\t<span class="topIcon" id="platformIcon-${e}"></span>\n\t\t\t</span>\n\t\t\t${"maw" === e ? "<span class=\"userName\"></span>" : ""}\n\t\t</span>\n\t\t<span class="navArrow"></span>\n\t\t<div class="menuBox">\n\t\t\t${"maw" === e ? `<div id="PFlogInWrapper" loggedin="false">\n\t\t\t\t\t<div class="userBox">\n\t\t\t\t\t\t<span class="userName"></span>\n\t\t\t\t\t\t<span class="platformIcon-${e}"></span>\n\t\t\t\t\t</div>\n\t\t\t\t\t${Z(fa() || n, "in", i, o)}\n\t\t\t\t\t${Z(fa() || n, "out", i, o)}\n\t\t\t\t</div>` : ""}\n\t\t\t<div class="linkWrapper">\n\t\t\t\t${"regions" === e ? va(t) : ua(t)}\n\t\t\t</div>\n\t\t</div>\n\t</li>`
    }
    ;
    class ga extends HTMLElement {
        get header() {
            return document.querySelector("platform-header").shadowRoot
        }
        get collections() {
            return [this.header.querySelectorAll(".topNavItem"), this.header.querySelectorAll(".subNavItem"), this.header.querySelectorAll(".topItem")]
        }
        get navContainer() {
            return this.header.querySelector("#PFnavContainer")
        }
        get isComeUntoChrist() {
            var t, e, n;
            return null === (t = window) || void 0 === t ? void 0 : null === (e = t.platformConfig) || void 0 === e ? void 0 : null === (n = e.headerConfig) || void 0 === n ? void 0 : n.isComeUntoChrist
        }
        get mobileBreadcrumb() {
            return this.header.querySelector("#PFmobileBreadcrumb")
        }
        constructor() {
            super(),
            this.addEventListener("mouseup", t=>{
                t.stopPropagation(),
                this.toggleMenu(t.target),
                this.firstChild.classList.add("wasClicked")
            }
            , !0),
            this.addEventListener("keydown", t=>{
                const e = t.which || t.keyCode;
                13 !== e && 32 !== e || this.toggleMenu(t.target)
            }
            )
        }
        addMenuItem(t, e, n) {
            const a = wa(t, e, n);
            this.innerHTML = a
        }
        toggleMenu(t) {
            t.hasAttribute("active") ? t.removeAttribute("active") : (J.clearActiveItems(Y(), t),
            t.setAttribute("active", !0)),
            (document.body.clientWidth < 841 || !this.isComeUntoChrist) && (this.navContainer.setAttribute("data-breadcrumbs", !0),
            this.mobileBreadcrumb.innerText = this.innerText.split("\n")[0])
        }
        handleSignIn(t) {
            Z(t)
        }
    }
    window.customElements.define("platform-account-item", ga);
    const ha = (t,o)=>{
        let r = null;
        return function() {
            for (var e = arguments.length, l = new Array(e), $ = 0; $ < e; $++)
                l[$] = arguments[$];
            null === r && (r = setTimeout(()=>{
                t.apply(this, l),
                r = null
            }
            , o))
        }
    }
    ;
    const xa = "\n<!-- SUB NAV -->\n<nav id=\"PFsubNav\" style=\"display: none;\" class=\"easeIn-defer\">\n\t<div id=\"PFsubNavTitle\" style=\"display: none;\" class=\"easeIn-defer\"></div>\n\t<div class=\"scrollArrow\" id=\"scrollLeft\"></div>\n\t<div id=\"PFsubNavLinks\" style=\"display: none;\" class=\"easeIn-defer\"></div>\n\t<div class=\"scrollArrow\" id=\"scrollRight\"></div>\n\t</div>\n</nav>";
    class ia extends HTMLElement {
        get subNavContainer() {
            return this.querySelector("nav")
        }
        get subNavTitle() {
            return this.querySelector("#PFsubNavTitle")
        }
        get subNavLinks() {
            return this.subNavContainer.querySelector("#PFsubNavLinks")
        }
        get scrollLeft() {
            return this.hasAttribute("scroll-left")
        }
        get scrollRight() {
            return this.hasAttribute("scroll-right")
        }
        get leftArrow() {
            return this.subNavContainer.querySelector("#scrollLeft")
        }
        get rightArrow() {
            return this.subNavContainer.querySelector("#scrollRight")
        }
        get rtl() {
            return this.hasAttribute("rtl")
        }
        set rtl(t) {
            t ? this.setAttribute("rtl", "true") : this.removeAttribute("rtl")
        }
        set scrollLeft(t) {
            t ? this.setAttribute("scroll-left", "") : this.removeAttribute("scroll-left")
        }
        set scrollRight(t) {
            t ? this.setAttribute("scroll-right", "") : this.removeAttribute("scroll-right")
        }
        static get observedAttributes() {
            return ["rtl"]
        }
        constructor() {
            super(),
            this.subNavData = {},
            this.innerHTML = xa
        }
        connectedCallback() {
            this.subNavLinks.addEventListener("scroll", ha(()=>this.hasOverflow(), 175)),
            this.leftArrow.addEventListener("click", ()=>this.handleLeftClick()),
            this.rightArrow.addEventListener("click", ()=>this.handleRightClick()),
            setTimeout(()=>{
                this.hasOverflow()
            }
            , 100)
        }
        setSubNavData(t) {
            return this.subNavData = t,
            this.subNavContainer.style.display = "flex",
            this
        }
        setSubNavTitle() {
            const {subNavTitleURL: t="", subNavTitle: s=""} = this.subNavData;
            this.subNavTitle.innerHTML = t ? `<a href=${t}>${s}</a>` : `${s}`
        }
        hasOverflow() {
            const t = this.subNavContainer.offsetWidth
              , s = this.rtl ? Math.floor(this.subNavLinks.firstChild.getBoundingClientRect().right) : Math.floor(this.subNavLinks.lastChild.getBoundingClientRect().left)
              , e = this.subNavLinks.scrollLeft
              , i = s > t;
            this.scrollLeft = e > 0,
            this.scrollRight = !!i
        }
        handleLeftClick() {
            const t = this.subNavContainer.offsetWidth
              , s = this.subNavLinks.scrollLeft;
            this.subNavLinks.scroll({
                left: s - t / 2,
                behavior: "smooth"
            })
        }
        handleRightClick() {
            const t = this.subNavContainer.offsetWidth
              , s = this.subNavLinks.scrollLeft;
            this.subNavLinks.scroll({
                left: s + t / 2,
                behavior: "smooth"
            })
        }
        attributeChangedCallback() {
            this.rtl ? this.subNavContainer.setAttribute("dir", "rtl") : this.subNavContainer.setAttribute("dir", "ltr")
        }
    }
    window.customElements.define("platform-subnav", ia);
    const Q = function() {
        let e = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {}
          , t = arguments.length > 1 ? arguments[1] : void 0
          , a = arguments.length > 2 ? arguments[2] : void 0;
        if ("/search" === window.location.pathname)
            return;
        let r = "";
        const o = encodeURIComponent(a)
          , n = e.searchPath || t.searchPath
          , l = e.searchEndpoint || t.searchEndpoint
          , s = e.searchQueryParam || t.searchQueryParam
          , c = e.searchOptionalParams || t.searchOptionalParams;
        if ("" !== o || void 0 !== o) {
            r = `https://${n}${l}?lang=${Platform.lang || "eng"}&${s}=${o}`;
            const e = ()=>{
                let e = "";
                return (c || []).map(t=>{
                    e = e.concat(`&${t.param}=${t.value}`)
                }
                ),
                e
            }
            ;
            window.location.assign(r + e())
        }
    }
      , ya = (e,t,a)=>{
        e.stopPropagation();
        let r = t;
        window.LDSprops.searchValue = r.trim();
        let o = document.getElementsByClassName("searchCB");
        Array.prototype.map.call(o, e=>{
            e.parentNode.removeChild(e)
        }
        ),
        a.innerHTML = "",
        window.callsearch = e=>{
            e.length > 0 ? a.style.display = "flex" : a.style.display = "none",
            e.map((e,t)=>{
                let r = document.createElement("li");
                r.classList.add("searchOption"),
                r.tabIndex = 0,
                r.innerHTML = `<strong>${window.LDSprops.searchValue || ""}</strong>${e.toLocaleLowerCase().replace(window.LDSprops.searchValue.toLocaleLowerCase(), "")}`,
                r.setAttribute("index", t),
                a.appendChild(r)
            }
            )
        }
        ;
        let n = document.createElement("script");
        n.classList.add("searchCB"),
        n.src = encodeURI(`https:${window.Platform.host}/services/platform/v3/resources/search-suggest?q=${encodeURIComponent(r)}&callback=callsearch`),
        document.getElementsByTagName("head")[0].appendChild(n)
    }
      , za = (e,t,a,r)=>{
        const o = document.querySelector("platform-header").shadowRoot.querySelector("platform-search");
        switch (e.which || e.key) {
        case 13:
            e.preventDefault(),
            e.target.blur(),
            "" !== e.target.value && Q(K, o.searchConfig, e.target.value);
            break;
        case 27:
            r ? (e.target.blur(),
            a.style.display = "none") : (o.removeAttribute("visible"),
            t.value = "");
            break;
        case 38:
            e.preventDefault(),
            a.children[a.children.length - 1].focus();
            break;
        case 40:
            e.preventDefault(),
            a.firstChild.focus();
        }
    }
      , Aa = (e,t,a,r)=>{
        const o = document.querySelector("platform-header").shadowRoot.querySelector("platform-search")
          , n = a.children
          , l = parseInt(e.target.getAttribute("index"), 10)
          , s = ()=>{
            t.focus(),
            t.select(),
            t.value = LDSprops.searchValue,
            t.style.userSelect = "all"
        }
        ;
        switch (e.which || e.key) {
        case 27:
            r ? (o.removeAttribute("visible"),
            t.value = "") : (t.blur(),
            a.style.display = "none");
            break;
        case 13:
        case 32:
            e.preventDefault(),
            "" !== e.target.innerText && (Q(K, o.searchConfig, e.target.innerText),
            a.style.display = "none");
            break;
        case 38:
            e.preventDefault(),
            0 === l ? s() : l < n.length && n[l - 1].focus();
            break;
        case 40:
            e.preventDefault(),
            l < n.length - 1 ? n[l + 1].focus() : s();
        }
    }
    ;
    const Ba = (e,t)=>{
        let o;
        return function() {
            clearTimeout(o),
            o = setTimeout(()=>e.apply(this, arguments), t)
        }
    }
    ;
    const Ca = "\n<!-- SEARCH CONTAINER -->\n<div id=\"PFsearchContainer\" style=\"display: none;\">\n  <form id=\"PFsearchForm\">\n  <input\n    tabindex=\"-1\"\n    type=\"text\"\n    autocomplete=\"off\"\n    id=\"PFsearchBox\"\n    form=\"PFsearchForm\"\n    inputmode=\"text\"\n    list=\"PFsearchSuggest\"\n    aria-label=\"Search Form\"\n  />\n  <div id=\"PFsubmitSearch\" role=\"button\" tabindex=\"-1\">\n    <span class=\"PFsearchIcon\">\n      <svg\n        viewBox=\"0 0 24 24\"\n        xmlns=\"http://www.w3.org/2000/svg\"\n        style=\"width: 24px; height: 24px;\"\n      >\n        <path\n          fill=\"white\"\n          d=\"M21.07,19.65l-5-5a7.5,7.5,0,1,0-1.41,1.41l5,5a1,1,0,0,0,1.41-1.41Zm-6.72-5.3a6,6,0,1,1,0-8.49A6,6,0,0,1,14.35,14.35Z\"\n        ></path>\n      </svg>\n    </span>\n    <span id=\"PFsubmitSearchText\"></span>\n  </div>\n  <ul id=\"PFsearchSuggest\"></ul>\n  </form>\n</div>\n";
    class Da extends HTMLElement {
        get searchContainer() {
            return this.shadowRoot.querySelector("#PFsearchContainer")
        }
        get searchToggleButton() {
            return document.querySelector("platform-header").shadowRoot.querySelector("#PFsearchIcon")
        }
        get searchBox() {
            return this.shadowRoot.querySelector("input")
        }
        get submitSearchButton() {
            return this.shadowRoot.querySelector("#PFsubmitSearch")
        }
        get searchSuggestContainer() {
            return this.shadowRoot.querySelector("#PFsearchSuggest")
        }
        get visible() {
            return this.hasAttribute("visible")
        }
        set visible(e) {
            e ? this.setAttribute("visible", "") : this.removeAttribute("visible")
        }
        get isStatic() {
            return this.hasAttribute("static")
        }
        set isStatic(e) {
            e ? this.setAttribute("static", "") : this.removeAttribute("static")
        }
        static get observedAttributes() {
            return ["visible", "static"]
        }
        constructor() {
            super(),
            this.searchConfig = {};
            const e = this.attachShadow({
                mode: "open"
            });
            this.searchToggleButton.addEventListener("click", e=>{
                e.stopImmediatePropagation(),
                this.toggleSearch()
            }
            , !0),
            this.searchToggleButton.addEventListener("keydown", e=>{
                const t = e.which || e.key;
                e.stopPropagation(),
                13 !== t && 32 !== t || this.toggleSearch()
            }
            , !0),
            e.innerHTML = Ca
        }
        connectedCallback() {
            const e = window.Platform.supportsCE ? this.shadowRoot : this
              , t = document.createElement("link");
            t.rel = (e=>e.relList && e.relList.supports("preload"))(t) ? "preload" : "stylesheet",
            t.as = "style",
            t.href = `${window.Platform.assetPath}styles/searchContainer.css`,
            t.setAttribute("onload", "this.onload=null;this.rel='stylesheet'"),
            e.append(t),
            this.submitSearchButton.addEventListener("mouseup", e=>{
                let t = this.searchBox.value;
                "" !== t && Q(K, this.searchConfig, t)
            }
            ),
            this.searchBox.addEventListener("keydown", e=>{
                za(e, this.searchBox, this.searchSuggestContainer)
            }
            ),
            this.searchBox.addEventListener("keyup", Ba(e=>{
                ya(e, this.searchBox.value, this.searchSuggestContainer)
            }
            , 250)),
            this.searchSuggestContainer.addEventListener("keydown", e=>{
                Aa(e, this.searchBox, this.searchSuggestContainer)
            }
            ),
            this.searchSuggestContainer.addEventListener("mouseup", e=>{
                "" !== e.target.text && (this.searchBox.value = e.target.textContent,
                Q(K, this.searchConfig, e.target.textContent))
            }
            ),
            this.searchSuggestContainer.addEventListener("keyup", e=>{
                const t = e.which || e.key;
                38 !== t && 40 !== t && 9 !== t || (this.searchBox.value = e.target.textContent)
            }
            ),
            this.searchConfig !== {} && !0 === this.searchConfig.searchBoxStatic && this.setAttribute("static", !0),
            this.addEventListener("blur", e=>{
                setTimeout(()=>this.visible = !1, 200)
            }
            );
            const s = new URLSearchParams(window.location.search).get(this.searchConfig.searchQueryParam || "query");
            s && (this.searchBox.value = decodeURIComponent(s)),
            document.dispatchEvent(new CustomEvent("searchloaded"))
        }
        attributeChangedCallback() {
            const e = document.querySelector("platform-header").shadowRoot.querySelector("#PFbanner");
            this.isStatic ? (LDSprops.bannerActive ? this.searchContainer.style.cssText = `top: ${e && e.offsetHeight + 145}px; transition-property: none;` : this.searchContainer.style.cssText = "top: 145px; transition-property: none;",
            this.searchBox.tabIndex = 0,
            this.searchToggleButton.style.display = "none",
            this.submitSearchButton.tabIndex = 0,
            this.searchSuggestContainer.innerHTML = "",
            this.searchSuggestContainer.style.display = "none",
            this.searchBox.placeholder = K() && void 0 !== K().searchPlaceholderText ? K().searchPlaceholderText : this.searchConfig.searchPlaceholder || "Search Church sites") : this.visible ? (LDSprops.bannerActive ? this.searchContainer.style.top = `${e && e.offsetHeight + 145}px` : this.searchContainer.style.top = "145px",
            this.searchBox.placeholder = K() && void 0 !== K().searchPlaceholderText ? K().searchPlaceholderText : this.searchConfig.searchPlaceholder || "Search Church sites",
            this.searchBox.value = "",
            this.searchBox.focus(),
            this.searchBox.tabIndex = 0,
            this.submitSearchButton.tabIndex = 0,
            this.searchSuggestContainer.innerHTML = "",
            this.searchSuggestContainer.style.display = "none") : (this.searchContainer.style.top = "-500px",
            this.searchBox.tabIndex = -1,
            this.submitSearchButton.tabIndex = -1)
        }
        setSearchConfig(e) {
            this.searchConfig = e
        }
        toggleSearch() {
            !0 === this.visible ? this.visible = !1 : this.visible = !0
        }
        resetStatic() {
            this.isStatic && (this.isStatic = !1,
            this.isStatic = !0)
        }
    }
    window.customElements.define("platform-search", Da);
    const Ea = "\n  <!-- CONFERENCE BANNER -->\n  <a id=\"PFbannerText\" style=\"display: none;\" class=\"easeIn-defer\"></a>\n  <svg style=\"display: none;\" id=\"PFbannerCloseButton\" onclick=\"LDSprops.closeBanner()\"\n    viewBox=\"0 0 24 24\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns=\"http://www.w3.org/2000/svg\" role=\"image\">\n    <path fill=\"currentColor\" d=\"M11.4 13.06l4.596 4.597a.749.749 0 1 0 1.06-1.06l-4.595-4.597 4.596-4.596a.749.749 0 1 0-1.06-1.06l-4.597 4.595-4.596-4.596a.749.749 0 1 0-1.06 1.06l4.595 4.597-4.596 4.596a.749.749 0 1 0 1.06 1.06l4.597-4.595z\"></path>\n  </svg>"
      , Fa = "\n  <div tabindex=\"0\" id=\"PFmobileNavControls\">\n    <span id=\"PFmobileNavButton\" role=\"menuitem\" aria-label=\"Open Main Navigation\"></span>\n    <span id=\"PFmobileBreadcrumb\"></span>\n  </div>\n\n  <!-- LIGHT RAYS -->\n  <svg id=\"PFlightRays\" width='34' height='40' xmlns='http://www.w3.org/2000/svg'>\n    <defs>\n      <linearGradient x1='0%' y1='50%' y2='50%' id='a'>\n        <stop stop-color='var(--theme-page-header-nav-bg, #01b6d1)' stop-opacity='.6' offset='0%'/>\n        <stop stop-color='var(--theme-page-header-nav-bg, #01b6d1)' stop-opacity='.25' offset='100%'/>\n      </linearGradient>\n      <linearGradient x1='0%' y1='50%' y2='50%' id='b'>\n        <stop stop-color='var(--theme-page-header-nav-bg, #01b6d1)' stop-opacity='.35' offset='0%'/>\n        <stop stop-color='var(--theme-page-header-nav-bg, #01b6d1)' stop-opacity='.15' offset='100%'/>\n      </linearGradient>\n      <linearGradient x1='0%' y1='50%' x2='98.607%' y2='50%' id='c'>\n        <stop stop-color='var(--theme-page-header-nav-bg, #01b6d1)' stop-opacity='.6' offset='0%'/>\n        <stop stop-color='var(--theme-page-header-nav-bg, #01b6d1)' stop-opacity='.35' offset='100%'/>\n      </linearGradient>\n    </defs>\n    <g fill-rule='nonzero' fill='none'>\n      <path fill='url(#a)' d='M8 40V0h10.34l-7.755 40z'/>\n      <path fill='url(#b)' d='M8 40V3.93L33.984 40z'/>\n      <path fill='url(#a)' d='M8 40V0l15.64 40z'/>\n      <path fill='url(#c)' d='M10.598 40H7V0h3.598z'/>\n      <path fill='var(--theme-page-header-nav-bg, #01b6d1)' d='M0 0h8v40H0z'/>\n    </g>\n  </svg>\n\n  <!-- MAIN NAV -->\n  <div id=\"PFcomeUntoChrist\" style=\"display: none;\" class=\"easeIn-defer\"></div>\n  <nav id=\"PFmainNav\" style=\"display: none;\" class=\"easeIn-defer\" role=\"navigation\">\n    <ul id=\"PFmainNavLinks\"></ul>\n  </nav>\n\n  <!-- V3 SEARCH ICON -->\n  <span tabindex=\"0\" id=\"PFsearchIcon\" role=\"button\" aria-label=\"Toggle Search Box Button\">\n    <svg viewBox=\"0 0 24 24\" xmlns=\"http://www.w3.org/2000/svg\" style=\"width: 24px; height: 24px; display: none;\">\n      <path d=\"M21.07,19.65l-5-5a7.5,7.5,0,1,0-1.41,1.41l5,5a1,1,0,0,0,1.41-1.41Zm-6.72-5.3a6,6,0,1,1,0-8.49A6,6,0,0,1,14.35,14.35Z\"></path>\n    </svg>\n  </span>\n\n  <div id=\"PFoverlay\"></div>"
      , Ga = e=>{
        const t = document.querySelector("platform-header")
          , o = window.Platform.supportsCE ? t.shadowRoot : t
          , n = t.shadowRoot.querySelector("#PFbanner")
          , a = t.shadowRoot.querySelector("#PFnavContainer")
          , r = t.hasAttribute("loaded");
        if (!r) {
            const e = document.createElement("link");
            e.rel = "stylesheet",
            e.href = `${window.Platform.assetPath}styles/main.css`;
            const t = document.createElement("link");
            t.rel = (e=>e.relList && e.relList.supports("preload"))(t) ? "preload" : "stylesheet",
            t.as = "style",
            t.href = `${window.Platform.assetPath}styles/defer.css`,
            t.setAttribute("onload", "this.onload=null;this.rel='stylesheet'");
            const r = document.createElement("iframe");
            r.id = "inlineAuthorization",
            r.title = "Authorize user",
            r.width = "0",
            r.height = "0",
            r.style = "display: none;",
            r.src = `${window.Platform.host}/services/platform/v4/auth`,
            o.append(e, t, r),
            n.innerHTML = Ea,
            a.innerHTML = Fa
        }
        window.LDSprops = {
            hasHeaderLogo: !1,
            isLoggedIn: !1,
            isMobile: document.body.clientWidth < 841,
            searchValue: "",
            bannerActive: !1
        },
        window.Platform.headerMounted = !0;
        const i = t.shadowRoot
          , l = i.querySelector("#PFheadSpace")
          , s = e.mainNav
          , d = e.subNav
          , c = e.mainNav.search
          , p = i.querySelector("header")
          , m = i.querySelector("#PFmainNav")
          , u = i.querySelector("#PFprefBox")
          , h = i.querySelector("#PFcontrolPanel")
          , w = i.querySelector("#PFbanner")
          , v = i.querySelector("#PFbannerText")
          , g = i.querySelector("#PFmobileNavControls")
          , b = i.querySelector("#PFmobileNavButton")
          , y = i.querySelector("#PFmobileBreadcrumb")
          , f = i.querySelector("#PFoverlay")
          , $ = i.querySelector("#PFcomeUntoChrist")
          , C = s.activateContainerMode
          , S = e.topLinks.maw
          , P = e.topLinks.regions
          , L = e.logo;
        let x = null;
        const F = !0 === C ? i.querySelector("#PFsearchIconV4") : i.querySelector("#PFsearchIcon");
        d && d.subNavItems.length > 0 && void 0 !== d.subNavTitle && (x = new ia,
        i.appendChild(x),
        x.setSubNavData(d),
        p.getAttribute("dir") ? x.setAttribute("rtl", "true") : x.removeAttribute("rtl")),
        window.LDSprops.setURL = (e,t)=>{
            const o = RegExp(/(https?:)?\/\//)
              , n = t && !o.test(t) ? `${window.location.hostname}${t}` : t
              , a = `https:${window.Platform.host}/services/platform/v3/sign-out?return_uri=${n || s.returnUri || window.location.href}`
              , r = t || `https://${window.Platform.host}/services/platform/v3/login?return_uri=${window.location.href}`;
            return "signin" == e ? r : a
        }
        ,
        i.querySelector("#PFskipToMainContent").innerText = e.skipToMainContent || "Skip to Main Content",
        window.LDSprops.closeBanner = ()=>{
            w.style.display = "none",
            LDSprops.bannerActive = !1,
            i.cookie = `${e.banner && e.banner.name}-banner-off=true;max-age=1209600`,
            i.querySelector("platform-search").resetStatic()
        }
        ;
        let q = document.cookie.split(";").filter(t=>t.includes(`${e.banner && e.banner.name}-banner-off=true`));
        v && 0 == q.length && e.banner && "" !== e.banner.text && (v.innerText = e.banner.text,
        v.setAttribute("aria-label", e.banner.text),
        w.classList.add("active"),
        "" !== e.banner.url && (v.href = e.banner.url,
        LDSprops.bannerActive = !0),
        s.isComeUntoChrist ? w.style.display = "none" : w.style.display = "block");
        const k = o.querySelector("platform-search") || document.createElement("platform-search");
        o.append(k),
        !0 !== c.searchIconHidden && !0 !== c.searchBoxStatic || (F.style.display = "none");
        const N = document.createElement("div");
        N.id = "skipToMainContent",
        N.innerText = e.mainContentString || "main content",
        N.style.height = 0,
        N.style.visibility = "hidden",
        t.append(N);
        const A = (e,t)=>{
            let o = u && u.querySelector(`platform-account-item[data-name=${t}]`) || new ga;
            o.dataset.name = t,
            o.addMenuItem(e, t, s),
            u && u.appendChild(o)
        }
        ;
        s.isComeUntoChrist || A(P, "regions"),
        A(S, "maw");
        const M = (e,t,o)=>{
            e.forEach((n,a)=>{
                const r = new ea;
                r.addMenuItem(n, a, e.length, t, n.title),
                o.appendChild(r)
            }
            )
        }
          , E = i.querySelector("#PFmainNavLinks");
        M(e.mainNav.navigation, "top", E);
        if (E.children.length,
        !r && document.addEventListener("checkcontext", ()=>{
            E.innerHTML = ""
        }
        ),
        d.subNavItems.length > 0) {
            const e = i.querySelector("#PFsubNavLinks");
            M(d.subNavItems, "sub", e),
            x && x.setSubNavTitle()
        }
        const H = e=>{
            if (new RegExp(/https:\/\/(preview-)?(localhost|test|dev|int|stage|www)\.churchofjesuschrist\.org/).test(e.origin) && !e.data.redirect) {
                window.dispatchEvent(new CustomEvent("signinhit",{
                    detail: {
                        loggedin: e.data && e.data.loggedin
                    }
                })),
                window.platformCallback(e.data),
                window.removeEventListener("message", H);
                const t = window.Platform.host.includes("preview.") || window.Platform.host.includes("www.") ? "ChurchSSO" : "ChurchSSO-int";
                e.data.loggedin && !window.PFparsedCookie[t] && (i.querySelector("#inlineAuthorization").src = `https://${window.Platform.host}/services/platform/v3/set-wam-cookie`)
            } else
                window.dispatchEvent(new CustomEvent("signinhit",{
                    detail: {
                        loggedin: !1
                    }
                })),
                console.log("Could not pass message to front-end with user data")
        }
        ;
        window.addEventListener("message", H),
        (()=>{
            window.Platform.host,
            Platform.lang;
            window.platformCallback = e=>{
                if (window.PFdataLayer = {
                    info: {
                        language: Platform.lang,
                        loginStatus: `${e.loggedin ? "signed in" : "signed out"}`,
                        account: e.account
                    }
                },
                e.loggedin) {
                    window.LDSprops.isLoggedIn = !0,
                    window.Platform.loggedin = !0;
                    let a = i.querySelectorAll(".userName");
                    for (var t = 0; t < a.length; t++)
                        a[t].textContent = e.linkname;
                    if (i.querySelector("#PFlogInWrapper").setAttribute("loggedin", !0),
                    e.tools2 && e.tools2.tool.length > 0) {
                        var o = e.tools2.tool.map(e=>`<li class="navLink">\n\t\t\t\t\t\t\t\t\t<a href="${e.link}">\n\t\t\t\t\t\t\t\t\t\t${e.text}\n\t\t\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t\t</li>`).join("");
                        let t = i.querySelector("[data-ref='tools']").getElementsByTagName("ul")[0];
                        var n = i.querySelector("[data-ref='tools']").getElementsByTagName("ul")[0].innerHTML;
                        void 0 !== t ? t.innerHTML = n + o : console.warn("toolList is missing")
                    }
                    window.platformCallback = void 0,
                    Platform.callSignInCallback && Platform.callSignInCallback.call()
                }
                (e=>{
                    let {isLoggedIn: t, isMember: o, cookie: n} = e;
                    const a = t && o ? "COJC" : "CUC";
                    (!n || "CUC" === window.PFparsedCookie.PFpreferredHomepage && "COJC" === a) && (document.cookie = `PFpreferredHomepage=${a};path=/;domain=churchofjesuschrist.org;max-age=31536000;`)
                }
                )({
                    isLoggedIn: e.loggedin,
                    isMember: e.isMember,
                    cookie: window.PFparsedCookie.PFpreferredHomepage
                })
            }
        }
        )(s.signInServiceUrl);
        const I = ()=>{
            const e = Platform.rtl
              , t = t=>`${e ? "right" : "left"}: auto; ${e ? "left" : "right"}: var(--headerSpacing${t});`;
            document.body.clientHeight > window.innerHeight ? (F.style = t(16),
            u.style = t(24)) : (F.style = t(e ? 16 : 8),
            u.style = t(e ? 24 : 16))
        }
          , T = (e,t)=>{
            return Array.from(e.children).some(e=>e.id === t)
        }
        ;
        if (window.innerWidth < 841 && !1 === T(m, "PFprefBox") && m.appendChild(u),
        window.innerWidth < 841 || s.isComeUntoChrist ? i.querySelector("#PFmainHeader").classList.add("isMobile") : i.querySelector("#PFmainHeader").classList.remove("isMobile"),
        s.isComeUntoChrist) {
            var X, B, U;
            const e = null === (X = document.querySelector("#PFsubNavLogo")) || void 0 === X ? void 0 : null === (B = X.firstElementChild) || void 0 === B ? void 0 : B.cloneNode(!0)
              , t = null === (U = document.querySelector("#PFwaffle")) || void 0 === U ? void 0 : U.cloneNode(!0)
              , o = document.createElement("a")
              , n = document.createElement("nav");
            n.id = "CUCnav",
            o.appendChild(e),
            o.href = d.subNavTitleURL,
            $.append(o, n),
            t && m.appendChild(t),
            d.subNavItems.length > 0 && (M(d.subNavItems, "cuc", n),
            i.querySelector("#PFsubNav").classList.add("cuc"))
        }
        I(),
        !r && window.addEventListener("resize", ha(()=>{
            x && x.hasOverflow(),
            J.clearAll(),
            window.innerWidth < 841 ? (!1 === T(m, "PFprefBox") && m.appendChild(u),
            !s.isComeUntoChrist && i.querySelector("#PFmainHeader").classList.add("isMobile"),
            window.LDSprops.isMobile = !0,
            C && (h.style.right = "var(--headerSpacing8)")) : (!1 === T(l, "PFprefBox") && l.appendChild(u),
            !s.isComeUntoChrist && i.querySelector("#PFmainHeader").classList.remove("isMobile"),
            m.style.overflow = "",
            document.body.style.overflow = "",
            window.LDSprops.isMobile = !1,
            I(),
            g.hasAttribute("active") && R())
        }
        , 100));
        const R = e=>{
            const t = "block" === w.style.display
              , o = t && w.getBoundingClientRect().height;
            g.hasAttribute("active") ? (document.body.style = "overflow: auto;",
            f.style = "left: -6000px;",
            m.style = "overflow-y: auto; overflow-x: auto;",
            a.removeAttribute("data-breadcrumbs"),
            J.removeActive(g),
            J.removeActive(m),
            J.clearAll()) : (g.setAttribute("active", !0),
            J.setActive(g),
            J.setActive(m),
            document.body.style = "overflow: hidden;",
            f.style = !0 === Platform.rtl ? "right: 285px;" : "left: 285px;",
            m.style = "overflow-y: auto; overflow-x: hidden;",
            window.pageYOffset < 105 && window.scrollTo({
                top: t ? 105 + o : 105,
                behavior: "smooth"
            }))
        }
        ;
        !r && b.addEventListener("mouseup", e=>{
            R()
        }
        , !1),
        !r && g.addEventListener("keydown", e=>{
            "Enter" === e.key && R()
        }
        ),
        !r && y.addEventListener("click", ()=>{
            a.hasAttribute("data-breadcrumbs") ? (a.removeAttribute("data-breadcrumbs"),
            J.clearAll()) : a.setAttribute("data-breadcrumbs", !0)
        }
        , !1),
        !r && document.body.addEventListener("mouseup", e=>{
            const t = e.composedPath()[0];
            document.body.clientWidth < 841 || s.isComeUntoChrist ? t === f ? R() : J.clearAll() : J.clearAll(e.target)
        }
        , !1),
        k.setSearchConfig(s.search),
        k.shadowRoot.querySelector("#PFsubmitSearchText").textContent = s.search.searchButtonText || "Search",
        setTimeout(()=>{
            c && c.searchBoxStatic && k.setAttribute("static", "")
        }
        , 250),
        c && !0 === c.searchIconHidden && !0 !== c.searchBoxStatic && (F.style = "display: none;");
        !LDSprops.hasHeaderLogo && (()=>{
            let t = l.querySelector(".LDSMainlogo");
            t.innerHTML = L.icon,
            LDSprops.hasHeaderLogo = !0;
            let o = l.getElementsByClassName("PFhomeLink")[0];
            e.logoConfig.logoLink ? o.href = `${e.logoConfig.logoLink}?lang=${Platform.lang || "eng"}` : o.href = `https:${window.Platform.host}?lang=${Platform.lang || "eng"}`,
            t.style.display = "block"
        }
        )(),
        i.querySelector("#PFmainHeader").style.opacity = "1",
        i.querySelector("#PFmainLogo").title = void 0 === L.alt ? "" : L.alt,
        t.setAttribute("loaded", !0)
    }
    ;
    const Ha = o=>{
        document.querySelector("platform-footer").setData(o).manageCustomizations().createFooterLinks().createSocialLinks().createLegalLinks().createLogo()
    }
    ;
    const Ia = ()=>{
        let e = new Object;
        "" != window.location.search && window.location.search.slice(1).split("&").map(o=>{
            let r = o.split("=");
            e[r[0]] = r[1]
        }
        );
        let {dataConfig: {lang: o, langs: r, countryCode: t, feedbackID: a, signOutURL: n, mode: i, note: c}={}} = window.platformConfig || {}
          , l = {};
        if ("" !== document.cookie && document.cookie.split("; ").map(e=>{
            let o = e.split("=");
            l[o[0]] = o[1]
        }
        ),
        window.PFparsedCookie = l,
        !e.lang) {
            e.lang = o || l["lds-preferred-lang-v2"] || l["lds-preferred-lang"] || l["lds-preferred-clang"] || "eng";
            let r = "";
            Object.keys(e).map(o=>{
                r += "" == r ? `?${o}=${e[o]}` : `&${o}=${e[o]}`
            }
            )
        }
        let s = o || e.lang.substring(0, 3);
        const d = r || window.PlatformService && window.PlatformService.langs || [];
        let$ = `?lang=${s}` + `${d && d.length ? `&langs=${encodeURIComponent(d)}` : ""}` + `${t ? `&country-code=${t}` : ""}` + `${a ? `&feedbackId=${a}` : ""}` + `${n ? `&signout-url=${n}` : ""}` + `${i ? `&mode=${i}` : ""}` + `${c ? `&note=${c}` : ""}`
          , p = document.createElement("meta");
        p.name = "Search.Language",
        p.content = e.lang,
        document.querySelector("head").appendChild(p);
        const u = "published" !== i && window.location.host.includes("preview");
        let f = "www";
        f = "www";
        let g = `${u && "www" === f ? "preview" : u ? `preview-${f}` : f}.churchofjesuschrist.org`
          , y = `https://${g}`;
        const v = `${y}/services/platform/v3/resources/data${$}`;
        window.Platform = D({
            cdn2Path: `//${f}.ldscdn.org/cdn2`,
            cdnPath: `//${f}.ldscdn.org/cdn`,
            domain: `${g}`,
            host: `//${g}`,
            lang: s,
            langs: d,
            rtl: !1,
            loggedin: !1,
            signin: "signmein",
            signout: "signmeout",
            signouturl: "",
            isLoaded: !1,
            assetPath: `${y}/services/platform/v4/`
        }, window.Platform),
        window.digitalDataEvents = D(D({}, window.digitalDataEvents), {}, {
            pageView: "Page View"
        });
        let m = document.querySelector("platform-header")
          , h = document.querySelector("platform-footer");
        "urd" === s || "ara" === s || "pes" === s ? (window.Platform.rtl = !0,
        m && m.setAttribute("rtl", "true"),
        h && h.setAttribute("rtl", "true")) : (window.Platform.rtl = !1,
        m && m.removeAttribute("rtl"),
        h && h.removeAttribute("rtl"));
        const w = {
            credentials: u ? "include" : "omit"
        }
          , b = (window.Platform.supportsCE,
        v);
        fetch(b, w).then(e=>e.ok ? e.json() : Promise.reject(e)).then(e=>{
            let {headerConfig: {noHeader: o, activateContainerMode: r, signInServiceUrl: t, signOutServiceUrl: a, returnUri: n, isComeUntoChrist: i}={}, logoConfig: {logoLink: c, noFavicon: l}={}, subNavConfig: {subNavTitle: s, subNavTitleURL: d, subNavItems: $=[]}={}, searchConfig: {searchPath: p, searchEndpoint: u, searchQueryParam: f, searchOptionalParams: g, searchIconHidden: y, searchPlaceholderText: v, searchBoxStatic: m}={}, footerConfig: {noFooter: h, noMargin: w, forceMobile: b, footerLinks: {removeFooterLinks: F, appendFooterLinks: P, replaceFooterLinks: S, mainLinks: j=[]}={}, social: {removeSocialLinks: G, appendSocialLinks: z, replaceSocialLinks: O, socialLinks: k=[]}={}, storeLegal: C={}}={}} = window.platformConfig || {};
            return D(D({}, e), {}, {
                logoConfig: D(D({}, e.logo), {}, {
                    logoLink: c,
                    noFavicon: l || !1
                }),
                mainNav: D(D({}, e.mainNav), {}, {
                    activateContainerMode: r,
                    noHeader: o,
                    signInServiceUrl: t,
                    signOutServiceUrl: a,
                    returnUri: n,
                    activateContainerMode: r,
                    isComeUntoChrist: i,
                    search: D(D({}, e.mainNav.search), {}, {
                        searchPlaceholder: v || e.mainNav.search.searchPlaceholder,
                        searchPath: p || window.Platform.domain,
                        searchEndpoint: u || "/search",
                        searchQueryParam: f || "query",
                        searchOptionalParams: g,
                        searchIconHidden: y,
                        searchBoxStatic: m
                    })
                }),
                subNav: {
                    subNavTitle: s,
                    subNavTitleURL: d,
                    subNavItems: $
                },
                footer: D(D({}, e.footer), {}, {
                    noFooter: h,
                    noMargin: w,
                    forceMobile: b,
                    links: F ? e.footer.links = [] : !0 === S ? j.length ? j : e.footer.links : !0 === P && j.length ? j.concat(e.footer.links) : e.footer.links,
                    social: G ? e.footer.social = [] : !0 === O ? k.length ? k : e.footer.social : !0 === z && k.length ? k.concat(e.footer.social) : e.footer.social,
                    legal: D({
                        storeLegal: C
                    }, e.footer.legal)
                })
            })
        }
        ).then(e=>{
            const o = document.querySelector("platform-header")
              , r = document.querySelector("platform-footer");
            e.footer.noFooter ? r.style.display = "none" : Ha(e),
            e.mainNav.noHeader ? o.style.display = "none" : Ga(e),
            !0 === e.mainNav.activateContainerMode && (o.querySelector("#PFcontrolPanel").style.display = "flex",
            o.querySelector("#PFprefBox").style.display = "none",
            o.querySelector("#PFsearchIcon").style.display = "none")
        }
        , window.dispatchEvent(new CustomEvent("platformloaded")), Platform.isLoaded = !0).catch(e=>console.error(e))
    }
    ;
    var Ja = {};
    Ja = function(n) {
        return new Promise(function(e, o) {
            var r = document.createElement("script");
            r.async = !0,
            r.type = "text/javascript",
            r.charset = "utf-8",
            r.src = n,
            r.onerror = function(n) {
                r.onerror = r.onload = null,
                o(n)
            }
            ,
            r.onload = function() {
                r.onerror = r.onload = null,
                e()
            }
            ,
            document.getElementsByTagName("head")[0].appendChild(r)
        }
        )
    }
    ;
    var _, ja, Ka, La, Ma = false;
    function Na() {
        return ja || (ja = Oa()),
        ja
    }
    function Oa() {
        try {
            throw new Error
        } catch ($) {
            var e = ("" + $.stack).match(/(https?|file|ftp|chrome-extension|moz-extension):\/\/[^)\n]+/g);
            if (e)
                return ka(e[0])
        }
        return "/"
    }
    function ka(e) {
        return ("" + e).replace(/^((?:https?|file|ftp|chrome-extension|moz-extension):\/\/.+)\/[^/]+$/, "$1") + "/"
    }
    function Pa() {
        if (Ma)
            return;
        Ma = true;
        _ = {};
        ja = null;
        Ka = Na;
        _.getBundleURL = Ka;
        La = ka;
        _.getBaseURL = La
    }
    var V, Qa, la, Ra, Sa, W, Ta = false;
    function Ua(r) {
        Array.isArray(r) || (r = [r]);
        var e = r[r.length - 1];
        try {
            return Promise.resolve(require(e))
        } catch ($) {
            if ("MODULE_NOT_FOUND" === $.code)
                return new aa(function($, t) {
                    ma(r.slice(0, -1)).then(function() {
                        return require(e)
                    }).then($, t)
                }
                );
            throw $
        }
    }
    function ma(r) {
        return Promise.all(r.map(Wa))
    }
    function Va(r, e) {
        la[r] = e
    }
    function Wa(r) {
        var e;
        if (Array.isArray(r) && (e = r[1],
        r = r[0]),
        W[r])
            return W[r];
        var $ = (r.substring(r.lastIndexOf(".") + 1, r.length) || r).toLowerCase()
          , t = la[$];
        return t ? W[r] = t(Qa() + r).then(function(r) {
            return r && require.register(e, r),
            r
        }).catch(function(e) {
            throw delete W[r],
            e
        }) : void 0
    }
    function aa(r) {
        this.executor = r,
        this.promise = null
    }
    function ba() {
        if (Ta)
            return;
        Ta = true;
        V = {};
        Qa = (Pa(),
        _).getBundleURL;
        la = {};
        Ra = ma;
        (V = V = Ua).load = Ra;
        Sa = Va;
        V.register = Sa;
        W = {};
        aa.prototype.then = function(r, e) {
            return null === this.promise && (this.promise = new Promise(this.executor)),
            this.promise.then(r, e)
        }
        ,
        aa.prototype.catch = function(r) {
            return null === this.promise && (this.promise = new Promise(this.executor)),
            this.promise.catch(r)
        }
    }
    (ba(),
    V).register("js", Ja);
    const Xa = ()=>{
        if (!document.querySelector("platform-header")) {
            const e = document.createElement("platform-header");
            document.body.prepend(e)
        }
    }
      , na = ()=>{
        if (!document.querySelector("platform-footer")) {
            const e = document.createElement("platform-footer");
            document.body.append(e)
        }
    }
    ;
    !function() {
        (ba(),
        V)([["HeaderSkeleton.36363b7f.js", "qSvt"], "qSvt"]).then(Xa),
        (ba(),
        V)([["Footer.d28dacb3.js", "BHco"], "BHco"]).then(na);
        const e = document.createElement("meta");
        e.name = "viewport",
        e.content = "width=device-width, initial-scale=1";
        const t = document.createElement("meta");
        t.property = "fb:pages",
        t.content = "18523396549";
        const n = document.createElement("meta");
        n.property = "fb:pages",
        n.content = "120694114630885";
        const r = document.createElement("meta");
        r.name = "Search.Language",
        r.content = "eng";
        const c = document.createElement("script");
        c.type = "application/javascript";
        c.src = "//cdn.churchofjesuschrist.org/cdn2/csp/ldsorg/abn/abn-scripts.js";
        const o = document.createElement("script");
        o.src = "//assets.adobedtm.com/05064fe6cab0/b9d37f296ace/launch-fe44d8adbb98.min.js",
        window.location.href.toLowerCase().includes("comeuntochrist") || (o.onload = ()=>{
            const e = document.createElement("script");
            e.type = "application/javascript",
            e.defer = "true",
            //e.innerHTML = "\n        if (typeof utag_data === \"undefined\") {\n          utag_data = {};\n        }\n        (function(a, b, c, d) {\n          a = \"https://edge.ldscdn.org/cdn2/csp/ldsorg/scripts/tracking.js\";\n          b = document;\n          c = \"script\";\n          d = b.createElement(c);\n          d.src = a;\n          d.type = \"text/java\" + c;\n          d.async = true;\n          a = b.getElementsByTagName(c)[0];\n          a.parentNode.insertBefore(d, a);\n        })();",
            document.body.append(e)
        }
        );
        const s = document.createElement("script");
        s.type = "application/javascript",
        s.innerHTML = "window.PlatformService = { langs: [] };";
        const a = document.createElement("link");
        a.rel = "preconnect",
        a.href = "https://edge.ldscdn.org";
        const d = document.createElement("link");
        d.rel = "shortcut icon",
        d.href = "https://www.churchofjesuschrist.org/services/platform/v3/resources/static/image/favicon.ico";
        const l = document.createElement("link");
        l.rel = "stylesheet",
        l.href = `${window.Platform.assetPath}vars`;
        const i = document.createElement("style");
        i.innerHTML = `@import "${window.Platform.assetPath}global-header-footer.css"`;
        const u = document.createElement("link");
        u.rel = "preconnect",
        u.href = "https://fonts.googleapis.com";
        const m = e=>e.relList && e.relList.supports("preload")
          , p = document.createElement("link");
        p.rel = m(p) ? "preload" : "stylesheet",
        p.as = "style",
        p.href = "https://foundry.churchofjesuschrist.org/Foundry/v1/Ensign:Sans:400/css",
        p.setAttribute("onload", "this.onload = null; this.rel = 'stylesheet'");
        const h = document.createElement("link");
        h.rel = m(h) ? "preload" : "stylesheet",
        h.as = "style",
        h.href = "https://foundry.churchofjesuschrist.org/Foundry/v1/Ensign:Sans:600/css",
        h.setAttribute("onload", "this.onload = null; this.rel = 'stylesheet'"),
        document.head.append(e, t, n, r, c, s, d, a, i, u, l, o, p, h),
        document.addEventListener("headerloaded", Ia),
        document.addEventListener("checkcontext", ()=>{
            document.dispatchEvent(new CustomEvent("headerloaded")),
            na()
        }
        )
    }();
    return {
        "jI1x": {}
    };
});
