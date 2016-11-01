var EditorSection = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, current_selection: null, event_slug: this.props.event_slug, category: this.props.category, event_id: this.props.event_id}
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
    onAddedNewItem: function(item) {
        this.setState({current_selection: item})
    },
    render: function() {
        return (
           <div>
                <EditorAsideNav items={this.props.items} handleSelectItem={this.selectItem} handleRefreshNav={this.refreshNav} />
                <EditorPanelContainer current_selection={this.state.current_selection} handleOnPanelUpdate={this.onPanelUpdate} event_slug={this.state.event_slug} event_id={this.state.event_id}  category={this.state.category} onAddedNewItem={this.onAddedNewItem}/>
            </div>
        )
   } 
});

