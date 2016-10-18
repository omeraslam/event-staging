var EditorSection = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, current_selection: this.props.current_selection}
    },
    getDefaultProps: function() {
        return { items: [], current_selection: null}
    },

    componentDidMount: function() {
   
    },

    selectItem: function(item) {

        this.setState({current_selection: item})

    },

    render: function() {
        
        return (
           <div>
                <EditorAsideNav items={this.props.items} handleSelectItem={this.selectItem} />
                <EditorPanelContainer current_selection={this.state.current_selection} />
            </div>
        )
   } 
});

