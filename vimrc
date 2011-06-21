" Switch syntax highlighting on
syntax on

" always show ruler at bottom
set ruler

" don't make foo~ files
set nobackup

" searching
set ignorecase
set smartcase
set hlsearch

" indentation
set autoindent
set smartindent
set smarttab
set tabstop=4
set shiftwidth=4

" whitespace
if has("multi_byte")
	set encoding=utf-8
	set list listchars=tab:»·,trail:·
else
	set list listchars=tab:>-,trail:.
endif

" disable mouse integration
set mouse=

function! AddQtSyntax()
    if expand( "<amatch>" ) == "cpp"
        syn keyword qtKeywords     signals slots emit Q_SLOTS Q_SIGNALS
        syn keyword qtMacros       Q_OBJECT Q_WIDGET Q_PROPERTY Q_ENUMS Q_OVERRIDE Q_CLASSINFO Q_SETS SIGNAL SLOT Q_DECLARE_PUBLIC Q_DECLARE_PRIVATE Q_D Q_Q Q_DISABLE_COPY Q_DECLARE_METATYPE Q_PRIVATE_SLOT Q_FLAGS Q_INTERFACES Q_DECLARE_INTERFACE Q_EXPORT_PLUGIN2 Q_GADGET Q_SCRIPTABLE Q_INVOKABLE METHOD Q_ARG Q_RETURN_ARG Q_GLOBAL_STATIC Q_GLOBAL_STATIC_WITH_ARGS Q_ASSERT QVERIFY QCOMPARE Q_UNUSED
        syn keyword qtCast         qt_cast qobject_cast qvariant_cast qstyleoption_cast qgraphicsitem_cast
        syn keyword qtTypedef      uchar uint ushort ulong Q_INT8 Q_UINT8 Q_INT16 Q_UINT16 Q_INT32 Q_UINT32 Q_LONG Q_ULONG Q_INT64 Q_UINT64 Q_LLONG Q_ULLONG pchar puchar pcchar qint8 quint8 qint16 quint16 qint32 quint32 qint64 quint64 qlonglong qulonglong qreal
        syn keyword kdeKeywords    k_dcop k_dcop_signals
        syn keyword kdeMacros      K_DCOP ASYNC PHONON_ABSTRACTBASE PHONON_OBJECT PHONON_HEIR PHONON_ABSTRACTBASE_IMPL PHONON_OBJECT_IMPL PHONON_HEIR_IMPL PHONON_PRIVATECLASS PHONON_PRIVATEABSTRACTCLASS K_DECLARE_PRIVATE K_D K_EXPORT_PLUGIN K_PLUGIN_FACTORY K_PLUGIN_FACTORY_DEFINITION K_PLUGIN_FACTORY_DECLARATION K_GLOBAL_STATIC K_GLOBAL_STATIC_WITH_ARGS
        syn keyword cRepeat        foreach Q_FOREACH
        syn keyword cRepeat        forever

        hi def link qtKeywords          Statement
        hi def link qtMacros            Type
        hi def link qtCast              Statement
        hi def link qtTypedef           Type
        hi def link kdeKeywords         Statement
        hi def link kdeMacros           Type
    endif
endfunction

function! AddDoxygenSyntax()
    if expand( "<amatch>" ) == "cpp"
        syn keyword cTodo contained TODO FIXME XXX todo
    endif
endfunction

autocmd Syntax * call AddQtSyntax()
autocmd Syntax * call AddDoxygenSyntax()
