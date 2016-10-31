var EditorSection = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, current_selection: null, event_slug: this.props.event_slug, category: this.props.category}
    },
    getDefaultProps: function() {
        return { items: [], current_selection: null}
    },

    componentDidMount: function() {
   
    },

    componentWillReceiveProps: function(nextProps) {
        this.setState({category: nextProps.category})
    },
    selectItem: function(item) {

        this.setState({current_selection: item})

    },
    onPanelUpdate: function() {

    },
    refreshNav: function() {

    },
    render: function() {
        return (
           <div>
                <EditorAsideNav items={this.props.items} handleSelectItem={this.selectItem} handleRefreshNav={this.refreshNav} />
                <EditorPanelContainer current_selection={this.state.current_selection} handleOnPanelUpdate={this.onPanelUpdate} event_slug={this.state.event_slug} category={this.state.category}/>
            </div>
        )
   } 
});

