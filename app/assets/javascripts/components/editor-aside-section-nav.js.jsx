var EditorAsideSectionNav = React.createClass({
    getInitialState: function() {
        return { "sections" : [{"title": "Event Details", "subheader": "Manage the primary event details", "icon": "fa fa-fw fa-calendar"}, 
                                {"title": "Registration + Ticketing", "subheader": "Nullam sed maximus ante", "icon": "fa fa-fw fa-calendar"},
                                {"title": "URL + Visibility", "subheader": "Nullam sed maximus ante", "icon": "fa fa-fw fa-calendar"},
                                {"title": "Design + Theme", "subheader": "Nullam sed maximus ante", "icon": "fa fa-fw fa-calendar"},
                                {"title": "SEO", "subheader": "Nullam sed maximus ante", "icon": "fa fa-fw fa-calendar"},
                                {"title": "Payment + Currency", "subheader": "Nullam sed maximus ante", "icon": "fa fa-fw fa-calendar"}
                                 ]}
    },

    render: function() {
        return (
            <ul className="editor-aside editor-aside-nav">

               {this.state.sections.map(function(section, index){
                    return <EditorAsideSectionNavItem key={index} item={section} />
                }.bind(this))}   

            </ul>
        )
    }
})