var EditorAsideSectionNav = React.createClass({

    getInitialState: function() {
        return { "sections" : [{"title": "Event Details", "subheader": "Edit your event details", "icon": "fa fa-fw fa-calendar", "category": "details"}, 
                                {"title": "Registration + Ticketing", "subheader": "General registration settings ", "icon": "fa fa-fw fa-ticket", "category": "tickets"},
                                {"title": "URL + Visibility", "subheader": "Change your event URL", "icon": "fa fa-fw fa-eye", "category": "url"},
                                //{"title": "Design + Theme", "subheader": "Nullam sed maximus ante", "icon": "fa fa-fw fa-calendar", "category": "design"},
                                //{"title": "SEO", "subheader": "Nullam sed maximus ante", "icon": "fa fa-fw fa-calendar"},
                                {"title": "Payment + Currency", "subheader": "Manage your payment info", "icon": "fa fa-fw fa-money", "category": "payment"}
                                 ]}
    },
    onSelectSectionNavItem: function(item) {
       
        this.props.handleSelectItem(item);

    },


    render: function() {
        return (
            <ul className="editor-aside editor-aside-nav">

               {this.state.sections.map(function(section, index){
                    return <EditorAsideSectionNavItem key={index} item={section} handleSelectSectionItem={this.onSelectSectionNavItem} />
                }.bind(this))}   

            </ul>
        )
    }
})